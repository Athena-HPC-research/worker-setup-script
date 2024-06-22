# Author: Apostolos Chalis <achalis@csd.auth.gr> 
# Slurm Worker Setup Script
#!/bin/bash
function display_help(){
	echo "Slurm Worker Setup Script"
	echo "Apostolos Chalis 2024 <achalis@csd.auth.gr"
	echo ""
	echo "--master-node-ip: Sets the master node IP"
	echo "--fs: Sets the NFS folder"
	echo ""
	echo "Slurm worker setup script."
	exit 1
}

# Parse command line arguments
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        --master-node-ip)
        MASTER_NODE_IP="$2"
        shift # past argument
        shift # past value
        ;;
        --fs)
        FILESYSTEM_FOLDER="$2"
        shift # past argument
        shift # past value
        ;;
	--help) 
	display_help
	shift 
	shift
	;;
   esac
done

# Requirements installation 
sudo apt install slurm-client nfs-common -y

# Creating shared FS mount point 
sudo mkdir /$MASTER_NODE_IP
sudo chown nobody.nogroup /$FILESYSTEM_FOLDER 
sudo chmod -R 777
# Editing /etc/fstab 
echo "$MASTER_NODE_IP:/$FILESYSTEM_FOLDER	/$FILESYSTEM_FOLDER	nfs	defaults	0 0" >> /etc/fstab

# Copying things from shared storage
sudo cp /$FILESYSTEM_FOLDER/munge.key /etc/munge/munge.key
sudo cp /$FILESYSTEM_FOLDER/slurm.conf /etc/slurm/slurm.conf
#sudo cp /$FILESYSTEM_FOLDER/cgroup* /etc/slurm # Probably not gonna need it



# Enabling needed daemons 
sudo systemctl enable --now munge 
sudo systemctl enable --now slurmd
