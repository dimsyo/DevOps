FROM nginx:1.25-alpine

# Copy custom hardened nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Security Hardening: Ensure correct ownership for non-root runtime
RUN touch /tmp/nginx.pid && \
    chown -R nginx:nginx /tmp/nginx.pid /var/cache/nginx /var/log/nginx /etc/nginx

USER nginx

EXPOSE 8080

HEALTHCHECK --interval=15s --timeout=5s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost:8080/nginx-health || exit 1
