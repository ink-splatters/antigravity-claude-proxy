# Testing

Run the test suite (requires server running):

```bash
# Start server in one terminal
bun start

# Run tests in another terminal
bun test
```

Individual tests:

```bash
bun run test:signatures    # Thinking signatures
bun run test:multiturn     # Multi-turn with tools
bun run test:streaming     # Streaming SSE events
bun run test:interleaved   # Interleaved thinking
bun run test:images        # Image processing
bun run test:caching       # Prompt caching
bun run test:strategies    # Account selection strategies
bun run test:cache-control # Cache control field stripping
```
