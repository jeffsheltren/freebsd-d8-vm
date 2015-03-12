C{
    #include <stdio.h>
    #include <unistd.h>

    char myhostname[255] = "";

}C


backend default {
    .host = "127.0.0.1";
    .port = "8080";
    .connect_timeout = 3600s;
    .first_byte_timeout = 3600s;
    .between_bytes_timeout = 3600s;
}

sub vcl_recv {
    C{
        if (myhostname[0] == '\0') {
            /* only get hostname once - restart required if hostname changes */
            gethostname(myhostname, 255);
        }
    }C

    #set defaults
    set req.grace = 30s;

    if (req.url ~ "^/cron.php$") {
        error 403 "Forbidden.";
    }

    # Cookie handling
    set req.http.Cookie = regsuball(req.http.Cookie, "(^|;\s*)(__[a-z]+|_ga|PRUM_EPISODES|has_js)=[^;]*", "");
    set req.http.Cookie = regsub(req.http.Cookie, "^;\s*", "");
    if (req.http.Cookie ~ "^\s*$") {
      unset req.http.Cookie;
      remove req.http.Cookie;
    }

    # Strip out Google Analytics campaign variables. They are only needed
    # by the javascript running on the page
    # utm_source, utm_medium, utm_campaign, gclid
    if(req.url ~ "(\?|&)(gclid|utm_[a-z]+)=") {
      set req.url = regsuball(req.url, "(gclid|utm_[a-z]+)=[^\&]+&?", "");
      set req.url = regsub(req.url, "(\?|&)$", "");
    }

    # Properly handle different encoding types
    if (req.http.Accept-Encoding) {
      if (req.url ~ "\.(jpg|png|gif|gz|tgz|bz2|tbz|mp3|ogg)$") {
        # No point in compressing these
        remove req.http.Accept-Encoding;
      } elsif (req.http.Accept-Encoding ~ "gzip") {
        set req.http.Accept-Encoding = "gzip";
      } elsif (req.http.Accept-Encoding ~ "deflate") {
        set req.http.Accept-Encoding = "deflate";
      } else {
        # unkown algorithm
        remove req.http.Accept-Encoding;
      }
    } 

    if (req.request != "GET" &&
      req.request != "HEAD" &&
      req.request != "PUT" &&
      req.request != "TRACE" &&
      req.request != "OPTIONS" &&
      req.request != "DELETE") {
        /* Non-RFC2616 or CONNECT which is weird. */
        return (pipe);
    }

    # Cache things with these extensions, and don't strip cookies from query
    # parameters ending in these extensions
    if (req.url ~ "\.(js|html|css|jpg|jpeg|png|gif|gz|tgz|bz2|tbz|mp3|ogg|swf)$" && req.url !~ "\?.+=") {
        unset req.http.Cookie;
        remove req.http.Cookie;
        return (lookup);
    }

    if (req.request != "GET" && req.request != "HEAD") {
      /* We only deal with GET and HEAD by default */
      return (pass);
    }
}

sub vcl_hash {
    hash_data(req.http.X-Forwarded-Proto);
}

sub vcl_fetch {
    # Use ban lurker friendly bans
    set beresp.http.x-url = req.url;
    set beresp.http.x-host = req.http.host;

    # Allow a 30 second grace period for caching "stale" data.
    set beresp.grace = 30s;

    # These status codes should always pass through and never cache.
    if (beresp.status == 404 || beresp.status == 503 || beresp.status == 500) {
        return (hit_for_pass);
    }

    if (beresp.ttl <= 0s) {
        return (hit_for_pass);
    }

    set beresp.ttl = 3600s;
    return (deliver);
}

sub vcl_deliver {
C{
    VRT_SetHdr(sp, HDR_RESP, "\014X-Cache-Svr:", myhostname, vrt_magic_string_end);
}C
    # Remove x-url/x-host from response used for ban lurker friendly bans
    unset resp.http.x-url;
    unset resp.http.x-host;

    /* mark hit/miss on the request */
    if (obj.hits > 0) {
        set resp.http.X-Cache = "HIT";
        set resp.http.X-Cache-Hits = obj.hits;
    } else {
        set resp.http.X-Cache = "MISS";
    }
}

sub vcl_error {
    if (obj.status == 503 && req.restarts < 5) {
        set obj.http.X-Restarts = req.restarts;
        return(restart);
    }
    if (obj.status >= 500 && obj.status <= 505) {
      set obj.http.Content-Type = "text/html; charset=utf-8";
      synthetic {"
        <html>
          <body>
            Our servers are currently a bit busy, please try refreshing the page after a few seconds.
            <br>
            Thanks!
          </body>
        </html>
     "};
    }
    return (deliver);
}

