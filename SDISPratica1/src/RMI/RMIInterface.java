package RMI;

import java.rmi.Remote;
import java.rmi.RemoteException;

public interface RMIInterface extends Remote {
	public int register(String license, String owner) throws RemoteException;
	public String lookup(String license) throws RemoteException;
}