Vagrant.configure("2") do |config|
    config.vm.box = "generic/arch"
 
    config.vm.provider :libvirt do |lv|
        lv.default_prefix = "veri_"
    end
 
    config.vm.provision "shell", inline: <<-SHELL
        pacman -Sy --noconfirm archlinux-keyring
        pacman -Syu --noconfirm
        pacman -S --noconfirm sudo python

        useradd -m user
        echo "user:pass" | chpasswd

        echo "user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/10-user
        chmod 440 /etc/sudoers.d/10-user
        
        sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf 
     
        sudo -u user bash -c '
            cd
            curl -L https://api.github.com/repos/rzesm/veri/tarball/main -o veri.tar.gz && tar -xzf veri.tar.gz
            cd rzesm-veri-*
            yes | ./sync
            yes | ./sync
        '
    SHELL
end 