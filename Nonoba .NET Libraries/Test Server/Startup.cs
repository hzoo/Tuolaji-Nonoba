using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;

namespace DevelopmentTestServer {
	public static class Startup {
		[STAThread]
		static void Main() {
			// Start the server and wait for incomming connection
			Nonoba.DevelopmentServer.Server.StartWithDebugging();

			// Start the server, and make it simulate one user connecting for 15seconds
			// (this is an easy way to debug serverside only code that runs every X timeslot...)
			//
			// Nonoba.DevelopmentServer.Server.StartWithDebugging(15000);
		}
	}
}