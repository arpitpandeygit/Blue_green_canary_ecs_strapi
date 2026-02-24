variable "env" {}
variable "subnets" {
  type = list(string)
}
variable "ecs_sg" {}
variable "blue_tg_arn" {}
variable "execution_role" {}
