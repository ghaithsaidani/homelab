# HomeLab

## 📌 Project Overview
This project automates the installation of **three Virtual Machines (VMs)** on a **KVM hypervisor** using **Vagrant** and provisions them into a **Kubernetes cluster** with:
- **1 Master Node**
- **2 Worker Nodes**  
  The provisioning and configuration are fully automated using **Ansible**.

---

## 🛠️ Technologies Used
- **[Vagrant](https://www.vagrantup.com/)** – VM creation and management
- **[KVM/QEMU](https://www.linux-kvm.org/)** – Virtualization hypervisor
- **[Ansible](https://www.ansible.com/)** – Configuration management and automation
- **[Kubernetes](https://kubernetes.io/)** – Container orchestration platform


---

## ⚙️ Prerequisites
Before starting, ensure you have:
- **Linux system** with KVM enabled
- **Vagrant** with the `vagrant-libvirt` plugin
- **Ansible** installed
- **Git** installed

---

## 🚀 Setup Instructions

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/ghaithsaidani/devops-stack-on-prom
cd devops-stack-on-prom
```


---

## 🖥️ Installation & Setup

1. Create SSH Keys for Each VM
```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/master_key -N ""
ssh-keygen -t rsa -b 4096 -f ~/.ssh/worker1_key -N ""
ssh-keygen -t rsa -b 4096 -f ~/.ssh/worker2_key -N ""
```
2. Start the Virtual Machines
```bash
vagrant up
```
3. Start the KVM Network
```bash
sudo virsh net-start vagrant-libvirt
```

4. Configure SSH Access
   1. Create (or edit) the SSH config file:
    ```bash
    nano ~/.ssh/config
    ```
    2. Add:
    ```bash
   Host master
    HostName 10.0.0.10 #master vm ip address
    User vagrant
    IdentityFile ~/.ssh/master_key

    Host worker1
    HostName 10.0.0.11 #worker1 vm ip address
    User vagrant
    IdentityFile ~/.ssh/worker1_key
    
    Host worker2
    HostName 10.0.0.12 #worker2 vm ip address
    User vagrant
    IdentityFile ~/.ssh/worker2_key
   ```
   3. Save and exit. Make sure the config file has proper permissions:
   ```bash
    chmod 600 ~/.ssh/config
   ```
5. Run the Ansible playbook
```bash
   ansible-playbook -i ansible/inventory.ini ansible/main.yml
```

---
## 📄 License
This project is licensed under the ***MIT License*** – feel free to modify and share.


---
## 📞 Contact

For further inquiries or assistance, feel free to reach out to me via [email](mailto:ghaith.saidani.contact@gmail.com) or [LinkedIn](https://www.linkedin.com/in/ghaithsaidani/).