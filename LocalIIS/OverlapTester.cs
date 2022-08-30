using System.Diagnostics;
using System.Net;
using System.Net.Sockets;
using System.Text;

namespace LocalIIS
{
    public class OverlapTester : IDisposable
    {
        private readonly int _processId = Process.GetCurrentProcess().Id;
        private readonly IPEndPoint _endpoint = new IPEndPoint(IPAddress.Loopback, 8091);

        private Socket? _server;

        public void StartServer()
        {
            try
            {
                _server = new Socket(_endpoint.AddressFamily, SocketType.Stream, ProtocolType.Tcp);
                _server.Bind(_endpoint);
                _server.Listen();

                _ = Task.Run(async () =>
                {
                    try
                    {
                        using var handler = await _server.AcceptAsync();

                        while (true)
                        {
                            var buffer = new byte[1_024];
                            var received = await handler.ReceiveAsync(buffer, SocketFlags.None);
                            var request = Encoding.UTF8.GetString(buffer, 0, received);
                            var clientProcessId = int.Parse(request);

                            if (clientProcessId != _processId)
                                throw new Exception($"Server process {_processId} still open for client {clientProcessId}");
                        }
                    }
                    catch (Exception ex)
                    {
                        Break(ex);
                    }
                });
            }
            catch(Exception ex)
            {
                Break(ex);
            }
        }

        public async Task VerifyServerAsync()
        {
            try
            {
                var client = new Socket(_endpoint.AddressFamily, SocketType.Stream, ProtocolType.Tcp);
                await client.ConnectAsync(_endpoint);
                var message = _processId.ToString();
                var messageBytes = Encoding.UTF8.GetBytes(message);
                await client.SendAsync(messageBytes, SocketFlags.None);
            }
            catch (Exception ex)
            {
                Break(ex);
            }
        }

        private void Break(Exception? ex = null)
        {
            Debugger.Launch();
            Debugger.Break();
        }

        public void Dispose()
        {
            using (_server)
            { }
        }
    }
}
