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
            
            System.out.println("Received this: " + received);
            
            InetAddress clientAddress = request.getAddress();
            int clientPort = request.getPort();
            
            byte[] buffer = new byte[512];
            buffer = ("This is a messgae").getBytes();
            DatagramPacket response = new DatagramPacket(buffer, buffer.length, clientAddress, clientPort);
            socket.send(response);
        }
    }
	
	private int register(String license, String owner) {
		return -1;
	}
	
	private String lookup(String license) {
		return "NOT_FOUND";
	}
}
