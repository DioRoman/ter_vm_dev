module "yandex-vpc" {
  source       = "./modules/yandex-vpc"
  env_name     = var.clickhouse[0].env_name
  subnets = [
    { zone = var.vpc_default_zone[2], cidr = var.vpc_default_cidr[0] }
  ]
  security_groups = [
    {
      name        = "clickhouse"
      description = "Security group for web servers"
      ingress_rules = [
        {
          protocol    = "TCP"
          port        = 80
          description = "HTTP access"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          protocol    = "TCP"
          port        = 443
          description = "HTTPS access"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          protocol    = "TCP"
          port        = 22
          description = "SSH access"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          protocol       = "TCP"
          description    = "Clickhouse HTTP default port"
          cidr_blocks    = ["0.0.0.0/0"]
          port           = 8123
        },
        {
          protocol       = "TCP"
          description    = "Clickhouse HTTP SSL/TLS default port"
          cidr_blocks    = ["0.0.0.0/0"]
          port           = 8443
        },
        {
          protocol       = "TCP"
          description    = "Clickhouse Native Protocol port"
          cidr_blocks    = ["0.0.0.0/0"]
          port           = 9000
        }
      ],
    egress_rules = [
        {
            protocol    = "ANY"
            description = "Allow all outbound traffic"
            cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    },
    {
      name        = "vector"
      description = "Security group for SSH access"
      ingress_rules = [
        {
          protocol    = "TCP"
          port        = 80
          description = "HTTP access"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          protocol    = "TCP"
          port        = 443
          description = "HTTPS access"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          protocol    = "TCP"
          port        = 22
          description = "SSH access"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ],
    egress_rules = [
      {
          protocol    = "ANY"
          description = "Allow all outbound traffic"
          cidr_blocks = ["0.0.0.0/0"]
      }
    ] 
    },
    {
      name        = "lighthouse"
      description = "Security group for SSH access"
      ingress_rules = [
        {
          protocol    = "TCP"
          port        = 80
          description = "HTTP access"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          protocol    = "TCP"
          port        = 443
          description = "HTTPS access"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          protocol    = "TCP"
          port        = 22
          description = "SSH access"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          protocol       = "TCP"
          description    = "Clickhouse HTTP default port"
          cidr_blocks    = ["0.0.0.0/0"]
          port           = 8123
        }
      ],
    egress_rules = [
        {
            protocol    = "ANY"
            description = "Allow all outbound traffic"
            cidr_blocks = ["0.0.0.0/0"]
        }
    ] 
    }
  ]
}

module "clickhouse-vm" {
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
  security_group_ids  = [module.yandex-vpc.security_group_ids["clickhouse"]]
  
  labels = {
    env  = var.clickhouse[0].env_name
    role = var.clickhouse[0].role
  }

  metadata = {
    user-data = data.template_file.cloudinit.rendered
    serial-port-enable = local.serial-port-enable
  }  
}

module "vector-vm" {
  source              = "./modules/yandex-vm"
  vm_name             = var.vector[0].instance_name 
  vm_count            = var.vector[0].instance_count
  zone                = var.vpc_default_zone[2]
  subnet_ids          = module.yandex-vpc.subnet_ids
  image_id            = data.yandex_compute_image.ubuntu.id
  platform_id         = var.vector[0].platform_id
  cores               = var.vector[0].cores
  memory              = var.vector[0].memory
  disk_size           = var.vector[0].disk_size 
  public_ip           = var.vector[0].public_ip
  security_group_ids  = [module.yandex-vpc.security_group_ids["vector"]]
  
  labels = {
    env  = var.vector[0].env_name
    role = var.vector[0].role
  }

  metadata = {
    user-data = data.template_file.cloudinit.rendered
    serial-port-enable = local.serial-port-enable
  }  
}

module "lighthouse-vm" {
  source              = "./modules/yandex-vm"
  vm_name             = var.lighthouse[0].instance_name 
  vm_count            = var.lighthouse[0].instance_count
  zone                = var.vpc_default_zone[2]
  subnet_ids          = module.yandex-vpc.subnet_ids
  image_id            = data.yandex_compute_image.ubuntu.id
  platform_id         = var.lighthouse[0].platform_id
  cores               = var.lighthouse[0].cores
  memory              = var.lighthouse[0].memory
  disk_size           = var.lighthouse[0].disk_size 
  public_ip           = var.lighthouse[0].public_ip
  security_group_ids  = [module.yandex-vpc.security_group_ids["lighthouse"]]
  
  labels = {
    env  = var.lighthouse[0].env_name
    role = var.lighthouse[0].role
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