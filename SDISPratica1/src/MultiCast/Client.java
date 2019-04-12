import java.io.IOException;
import java.net.DatagramPacket;
import java.net.InetAddress;
import java.net.MulticastSocket;
import java.net.SocketTimeoutException;

public class Client {

	public static void main(String[] args) {
		if (args.length != 4 && args.length != 5) {
            System.out.println("Syntax: Client <mcast_addr> <mcast_port> <oper> <opnd> *");
            return;
        }
		
        String mcast_addr = args[0];
        int mcast_port = Integer.parseInt(args[1]);
        String oper = args[2];
        
        try {
        	
        	//Multicast group joining ...
        	InetAddress addr = InetAddress.getByName(mcast_addr);
            MulticastSocket socket = new MulticastSocket(mcast_port);
            socket.joinGroup(addr);
 
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
            	
            	//Client needs to know where to send data, getting info from Server
            	byte[] bufReceivePort = new byte[256];
            	DatagramPacket receivePort = new DatagramPacket(bufReceivePort, bufReceivePort.length);
            	socket.receive(receivePort);
            	
            	String info = new String(receivePort.getData(), 0, receivePort.getLength());
            	String[] infoParts = info.split(" ");
            	
            	InetAddress address = InetAddress.getByName(infoParts[1]);
            	int port = Integer.parseInt(infoParts[0]);
            	            	
            	//Now that it knows the info it can proceed like normal
            	
                DatagramPacket request = new DatagramPacket(buf, buf.length, address, port);
                
                System.out.println("Sending to server adress " + infoParts[1] + " and port " + infoParts[0]);
                
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
