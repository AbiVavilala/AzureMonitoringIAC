variable "cpu_threshold" {
  description = "CPU threshold for alert"
  type        = number
  default     = 90
}

variable "frequency" {
  description = "How often to evaluate the alert rule"
  type        = string
  default     = "PT5M"
}

variable "window_size" {
  description = "Evaluation window for alert rule"
  type        = string
  default     = "PT5M"
}