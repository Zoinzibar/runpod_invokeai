## Invoke AI RunPod Template

** This template does not automatically launch invoke!! **

Please open a terminal window and run

`invokeai-configure`

This will lead you through configuring the invokeai template to your liking.

After it's done configuring, make sure to run the invokeai command with --host 0.0.0.0 as follows, or it will not listen on the correct interfaces and won't work!

`invokeai --web --host 0.0.0.0`

**Please wait for pod CPU utilization % to hit 0 before attempting to connect. CPU utilization generally means that your pod is working hard to get ready for you. You will probably get a 502 error if you don't!**
