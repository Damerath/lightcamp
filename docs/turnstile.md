# Registration Bot Protection

New registrations use Cloudflare Turnstile and a hidden honeypot field. Turnstile is verified server-side before Devise creates a user; a browser widget alone is not sufficient.

## Production configuration

1. Create a **Managed** Turnstile widget for the production hostname in the Cloudflare dashboard.
2. Set these environment variables on the application server, outside Git:

```text
TURNSTILE_SITE_KEY=...
TURNSTILE_SECRET_KEY=...
TURNSTILE_HOSTNAME=lightcamp.example.org
```

3. Restart Puma after changing the environment.
4. Submit one real registration and check the Cloudflare Turnstile analytics.

The application fails closed: if the token is absent, invalid, expired, reused, the hostname/action differs, or Cloudflare cannot be reached, it does not create an account.

Add a rate limit for `POST /users` at the reverse proxy as a separate layer. For example, permit a small burst and a sustained limit per client IP. This protects the app before requests reach Rails.
