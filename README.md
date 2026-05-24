# Chromium distributed build project

## References

- [Design Document: Remote Execution API](https://docs.google.com/document/d/1AaGk7fOPByEvpAbqeXIyE8HX_A3_axxNnvroblTZ_6s/edit?pli=1&tab=t.0#heading=h.ole76l21af90)

The project I chose to focus on is NativeLink
https://github.com/TraceMachina/nativelink

```bash
# Run the nativelink server
docker run -v $(pwd)/basic_cas.json5:/config -p 50051:50051 ghcr.io/tracemachina/nativelink:v1.3.0 config
```

```bash
# args.gn with remote execution enabled
gn gen out/Default --args='use_remoteexec=true is_debug=false'
# Start build
autoninja -C out/Default chrome
```
