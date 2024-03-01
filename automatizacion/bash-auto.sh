#!/bin/bash

# Validacion de argumentos
if [ "$#" -ne 7 ]; then
    echo "Uso: $0 <nombre_vm> <tipo_sistema_operativo> <num_cpus> <memoria_gb> <vram_mb> <tamaño_disco_gb> <nombre_controlador>"
    exit 1
fi

# Asignacion de argumentos a las variables de la maquina virtual
nombreVM=$1
tipoSO=$2
numCPU=$3
memoriaGB=$4
vramMB=$5
tamañoDIS_GB=$6
SATA=$7

# creacion de la maquina
VBoxManage createvm --name "$nombreVM" --ostype "$tipoSO" --register
# configuracion
VBoxManage modifyvm "$nombreVM" --cpus "$numCPU" --memory "$memoriaGB" --vram "$vramMB"
# creacion disco duro virtual
VBoxManage createmedium disk --filename "$nombreVM.vdi" --size "$tamañoDIS_GB"
# asignacion del disco duro a la maquina virtual
VBoxManage storagectl "$nombreVM" --name "SATA Controller" --add sata --controller IntelAHCI
VBoxManage storageattach "$nombreVM" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$nombreVM.vdi"
# creacion y acsociacion del controlador de la maquina
VBoxManage storagectl "$nombreVM" --name "IDE Controller" --add ide
VBoxManage storageattach "$nombreVM" --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium emptydrive
# Imprimir la configuración de la maquina virtual
echo "Configuracion de la nueva Máquina Virtual $nombreVM:"
VBoxManage showvminfo "$nombreVM" | grep "Name:\|Memory size\|Number of CPUs\|VRAM size\|SATA Controller\|IDE Controller"

echo "Finalizado."
