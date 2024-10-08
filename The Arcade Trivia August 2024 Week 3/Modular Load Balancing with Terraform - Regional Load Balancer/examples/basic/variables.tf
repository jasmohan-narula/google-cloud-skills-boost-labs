/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "region" {
  default = "us-east4"
}

variable "project_id" {
  description = "GCP Project used to create resources."
  default = "qwiklabs-gcp-03-d25cea18b7b0"
}

variable "image_family" {
  description = "Image used for compute VMs."
  default     = "debian-11"
}

variable "image_project" {
  description = "GCP Project where source image comes from."
  default     = "debian-cloud"
}
