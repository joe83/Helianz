using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using Helianz;
using HelianzServer;

namespace HelianzBusiness.Tests {
	class ServiceWrapper : MarshalByRefObject {
		public ServiceWrapper() {
			RemotingClient.HelianzBusinessIsLocal = true;

			// Connect to the local mysql server.
			DataConnection connection = new DataConnection();
			connection.SetDb("localhost", "helianz", "root", "", "root", "", DatabaseType.MySql);

			service = new HelianzService();
			thread = new Thread((ThreadStart)delegate() {
				service.ServiceWorkerMethod();
			});
		}

		private HelianzService service;
		public HelianzService Service {
			get { return service; }
		}

		private Thread thread;
		public Thread Thread {
			get { return thread; }
		}

		public void Start() {
			if (Thread.IsAlive)
				Stop();

			Thread.Start();
		}

		public void Stop() {
			if(Thread.IsAlive) {
				HelianzService.server.Stop();
				Thread.Abort();
			}
			while(Thread.IsAlive) {
				Thread.Sleep(100);
			}
		}
	}
}
