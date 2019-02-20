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
            
            System.out.println("here");
            DatagramSocket socket = new DatagramSocket();
            System.out.println("there");
 
            while (true) {
            	
            	byte[] buf = new byte[256];
 
            	if(args.length == 4) {
                	buf = (oper+" "+args[3]).getBytes();
            	}
            	
            	if(args.length == 5) {
            		buf = (oper+" "+args[3]+" "+args[4]).getBytes();
            	}
            	
                DatagramPacket request = new DatagramPacket(buf, buf.length, address, port_number);
                socket.send(request);
                
                System.out.println("sent");
 
                byte[] buffer = new byte[512];
                DatagramPacket response = new DatagramPacket(buffer, buffer.length);
                
                System.out.println("waiting");
                
                socket.receive(response);
                
                System.out.println("Server pulled through");
 
                String serverReply = new String(buffer, 0, response.getLength());
 
                System.out.println(serverReply);
                System.out.println();
 
                Thread.sleep(10000);
            }
 
        } catch (SocketTimeoutException ex) {
            System.out.println("Timeout error: " + ex.getMessage());
            ex.printStackTrace();
        } catch (IOException ex) {
            System.out.println("Client error: " + ex.getMessage());
            ex.printStackTrace();
        } catch (InterruptedException ex) {
            ex.printStackTrace();
        }
    }
}
