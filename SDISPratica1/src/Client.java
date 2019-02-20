import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketTimeoutException;

public class Client {

	public static void main(String[] args) {
		if (args.length != 4 && args.length != 5) {
            System.out.println("Syntax: Client <host_name> <port_number> <oper> <opnd>*");
            return;
        }
		
        String host_name = args[0];
        int port_number = Integer.parseInt(args[1]);
        String oper = args[2];
        
        try {
            InetAddress address = InetAddress.getByName(host_name);
            
            DatagramSocket socket = new DatagramSocket();
 
            while (true) {
            	
            	byte[] buf = new byte[256];
 
            	if(args.length == 4 && oper.equals("lookup")) {
                	buf = (oper+" "+args[3]).getBytes();
                	System.out.println("lookup "+args[3]);
            	}
            	
            	else if(args.length == 5 && oper.equals("register")) {
            		buf = (oper+" "+args[3]+" "+args[4]).getBytes();
            		System.out.println("register "+args[3]+args[4]);
            	}
            	
            	else {
            		System.out.println("invalid argument numbers for selected command");
            		socket.close();
            		return;
            	}
            	
                DatagramPacket request = new DatagramPacket(buf, buf.length, address, port_number);
                socket.send(request);

                byte[] buffer = new byte[512];
                DatagramPacket response = new DatagramPacket(buffer, buffer.length);
                
                socket.receive(response);
 
                String serverReply = new String(buffer, 0, response.getLength());
 
                System.out.println(serverReply);
                System.out.println();

                socket.close();
                break;
            }
 
        } catch (SocketTimeoutException ex) {
            System.out.println("Timeout error: " + ex.getMessage());
            ex.printStackTrace();
        } catch (IOException ex) {
            System.out.println("Client error: " + ex.getMessage());
            ex.printStackTrace();
        }
    }
}
