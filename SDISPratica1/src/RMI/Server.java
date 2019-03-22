package RMI;
import RMI.RMIInterface;
import java.rmi.AlreadyBoundException;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;
import java.util.ArrayList;
import java.util.List;

public class Server implements RMIInterface {
	
	private List<Registration> listOfRegistrations = new ArrayList<Registration>();
	
	public Server() {
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
	}

	public static void main(String[] args) {
		
		if(args.length != 1) {
			System.out.println("Invalid use, server must be called like so: Server <remote_object_name>");
			return;
		}
		
		String remote_name = args[0];
		
        try {
            Server server = new Server();
            RMIInterface stub = (RMIInterface) UnicastRemoteObject.exportObject(server, 0);
            
            // Bind the remote object's stub in the registry
            Registry registry = LocateRegistry.getRegistry();
            registry.bind(remote_name, stub);
            
            System.err.println("Server ready");
        } catch (RemoteException ex) {
            System.out.println("RMI error: " + ex.getMessage());
        } catch(AlreadyBoundException ex) {
        	System.out.println("RMI error: " + ex.getMessage());
        }
	}
	
    @Override
	public int register(String license, String owner) {
		
		boolean found = false;
		
		System.out.println("Registering license " + license + " to " + owner);
		
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
	
    @Override
	public String lookup(String license) {
    	
    	System.out.println("Looking up license " + license);
		
		for(int i = 0; i < listOfRegistrations.size(); i++) {
			if(listOfRegistrations.get(i).license.equals(license)) {
				return listOfRegistrations.get(i).owner;
			}
		}
		
		return "NOT_FOUND";
	}
}