import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketException;
import java.util.ArrayList;
import java.util.List;

public class Server {
	
	private DatagramSocket socket;
	private List<Registration> listOfRegistrations = new ArrayList<Registration>();
	
	public Server(int port) throws SocketException {
		
		Registration regis1 = new Registration("Paulo", "XX-XX-XX");
		Registration regis2 = new Registration("João", "XX-YX-4X");
		Registration regis3 = new Registration("Fábio", "ZX-3X-12");
		Registration regis4 = new Registration("Ric", "XX-2X-1X");
		Registration regis5 = new Registration("Maria", "VX-3X-XX");
		Registration regis6 = new Registration("Joana", "1X-2X-6X");
		
		listOfRegistrations.add(regis1);
		listOfRegistrations.add(regis2);
		listOfRegistrations.add(regis3);
		listOfRegistrations.add(regis4);
		listOfRegistrations.add(regis5);
		listOfRegistrations.add(regis6);
		
		socket = new DatagramSocket(port);
	}

	public static void main(String[] args) {
		
		if(args.length != 1) {
			System.out.println("Invalid use, server must be called like so: Server <port_number>");
			return;
		}
		
		int port_number = Integer.parseInt(args[0]);
		
        try {
            Server server = new Server(port_number);
            server.service();
        } catch (SocketException ex) {
            System.out.println("Socket error: " + ex.getMessage());
        } catch (IOException ex) {
            System.out.println("I/O error: " + ex.getMessage());
        }
	}
	
    private void service() throws IOException {
        while (true) {
        	byte[] buf = new byte[256];
            DatagramPacket request = new DatagramPacket(buf, buf.length);
            
            System.out.println("Server waiting for client!");
            
            socket.receive(request);
            
            String received = new String(request.getData(), 0, request.getLength());
            
            String[] receivedParts = received.split(" ");
            
            String responseString = "";
            
            if(receivedParts[0].equals("register")) {
            	System.out.println("register " + receivedParts[1] + " " + receivedParts[2]);
            	int result = register(receivedParts[1], receivedParts[2]);
            	responseString = responseString + result;
            	System.out.println(listOfRegistrations);
            }
            
            if(receivedParts[0].equals("lookup")) {
            	System.out.println("lookup " + receivedParts[1]);
            	String result = lookup(receivedParts[1]);
            	responseString = responseString + result;
            }
            
            System.out.println("Result: " + responseString);
            
            InetAddress clientAddress = request.getAddress();
            int clientPort = request.getPort();
            
            byte[] buffer = new byte[512];
            buffer = responseString.getBytes();
            DatagramPacket response = new DatagramPacket(buffer, buffer.length, clientAddress, clientPort);
            socket.send(response);
        }
    }
	
	private int register(String license, String owner) {
		
		boolean found = false;
		
		for(int i = 0; i < listOfRegistrations.size(); i++) {
			if(listOfRegistrations.get(i).license.equals(license)) {
				found = true;
			}
		}
		
		if(!found) {
			Registration newRegister = new Registration(owner, license);
			listOfRegistrations.add(newRegister);
			
			return listOfRegistrations.size();
		}
		
		else return -1;
	}
	
	private String lookup(String license) {
		
		for(int i = 0; i < listOfRegistrations.size(); i++) {
			if(listOfRegistrations.get(i).license.equals(license)) {
				return listOfRegistrations.get(i).owner;
			}
		}
		
		return "NOT_FOUND";
	}
}
