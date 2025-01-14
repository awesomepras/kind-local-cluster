# Step to troubleshoot
1. Verify docker network configuration is correct
```
docker network inspect custom-bridgename 
```
2. Ensure metallb configuration mathces the IP pool range in the network setup
3. Use port forwarding temporarily to check if service is available
```
kubectl port-forward svc/my-service 8080:80
```
4. Inspect docker logs if there is any failure due to API server
```
docker logs k3d-${CLUSTERNAME}-server-0
docker exec -it k3d-${CLUSTERNAME}-server-0 sh
```
5. No IP Assigned:
Check MetalLB logs:
```bash
kubectl logs -n metallb-system <controller-pod>
```
6. Confirm Masquerade Rule on master host : 
```sudo iptables -t nat -A POSTROUTING -s 192.168.3.0/24 ! -d 192.168.3.0/24 -j MASQUERADE```

7. Enable IP Forwarding on the master host where K8s Cluster is running 
>  Check if IP forwarding is enabled  
```cat /proc/sys/net/ipv4/ip_forward```

> If not enabled, enable it temporarily  
``` sudo sysctl -w net.ipv4.ip_forward=1 ``` 

> To make it persistent, update sysctl.conf
```
echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

8. Add route to Docker network on client network
```sudo ip route add 192.168.3.0/24 via 192.168.2.100```

9. Run tcpdump on master host running docker network
```sudo tcpdump -i any host 192.168.3.241```



