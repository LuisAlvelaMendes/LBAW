package RMI;
import java.io.IOException;
import java.rmi.NotBoundException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import RMI.RMIInterface;

public class Client {

	public static void main(String[] args) {
		if (args.length != 4 && args.length != 5) {
            System.out.println("Syntax: Client <host_name> <remote_object_name> <oper> <opnd> *");
            return;
        }
		
        String host_name = args[0];
        String remote_object  = args[1];
        String oper = args[2];
        
        try {
        	
            Registry registry = LocateRegistry.getRegistry(host_name);
            RMIInterface stub = (RMIInterface) registry.lookup(remote_object);
            
            if(oper.equals("lookup") && args.length == 4) {
                String response = stub.lookup(args[3]);
                System.out.println("Response: " + response);
                return;
            }
            
            else if(oper.equals("register") && args.length == 5) {
                String response = "amount of clients: " + stub.register(args[3], args[4]);
                System.out.println("Response: " + response);
                return;
            }
            
            else {
            	System.out.println("Invalid arguments. Gave operation " + oper + " with " + args.length + " arguments.");
            }
            
        } catch (IOException ex) {
            System.out.println("Client error: " + ex.getMessage());
            ex.printStackTrace();
        } catch (NotBoundException e) {
        	System.out.println("RMI error: " + e.getMessage());
		}
        
    }
}