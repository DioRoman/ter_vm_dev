variable "env_name" {
  description = "Имя окружения (используется в названиях ресурсов)"
  type        = string
}

variable "network_description" {
  description = "Описание создаваемой сети"
  type        = string
  default     = null
}

variable "labels" {
  description = "Метки для всех ресурсов"
  type        = map(string)
  default     = {}
}

variable "subnets" {
  description = "Список подсетей для создания"
  type = list(object({
    zone        = string
    cidr        = string
    description = optional(string)
  }))
  default = []
}

variable "security_group_ingress" {
  description = "Правила для входящего трафика"
  type = list(object({
    protocol       = string
    description    = string
    v4_cidr_blocks = list(string)
    port           = optional(number)
    from_port      = optional(number)
    to_port        = optional(number)
  }))
  default = [
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
    }
  ]
}

variable "security_group_egress" {
  description = "Правила для исходящего трафика"
  type = list(object({
    protocol       = string
    description    = string
    v4_cidr_blocks = list(string)
    port           = optional(number)
    from_port      = optional(number)
    to_port        = optional(number)
  }))
  default = [
    {
      protocol       = "ANY"
      description    = "Allow all outbound traffic"
      v4_cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}