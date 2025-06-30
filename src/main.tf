module "yandex-vpc" {
  source       = "./modules/yandex-vpc"
  env_name     = var.clickhouse[0].env_name
  subnets = [
    { zone = var.vpc_default_zone[2], cidr = var.vpc_default_cidr[0] }
  ]

  security_group_ingress = [
    {
      protocol       = "TCP"
      description    = "Allow SSH"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 22
    },
    {
      protocol       = "TCP"
      description    = "Allow HTTP"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 80
    },
    {
      protocol       = "TCP"
      description    = "Allow HTTPS"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 443
    },
    {
      protocol       = "TCP"
      description    = "Clickhouse Native Protocol port"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 9000
    },
    {
      protocol       = "TCP"
      description    = "Clickhouse HTTP default port"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 8123
    },
    {
      protocol       = "TCP"
      description    = "Clickhouse HTTP SSL/TLS default port"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 8443
    }
  ]
}

module "yandex-vm" {
  source              = "./modules/yandex-vm"
  vm_name             = var.clickhouse[0].instance_name 
  vm_count            = var.clickhouse[0].instance_count
  zone                = var.vpc_default_zone[2]
  subnet_ids          = module.yandex-vpc.subnet_ids
  image_id            = data.yandex_compute_image.ubuntu.id
  platform_id         = var.clickhouse[0].platform_id
  cores               = var.clickhouse[0].cores
  memory              = var.clickhouse[0].memory
  disk_size           = var.clickhouse[0].disk_size 
  public_ip           = var.clickhouse[0].public_ip
  security_group_ids  = [module.yandex-vpc.security_group_id]
  
  labels = {
    env  = var.clickhouse[0].env_name
    role = var.clickhouse[0].role
  }

  metadata = {
    user-data = data.template_file.cloudinit.rendered
    serial-port-enable = local.serial-port-enable
  }  
}

data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")
    vars = {
    ssh_public_key     = file(var.vm_ssh_root_key)
  }
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_image_family
}