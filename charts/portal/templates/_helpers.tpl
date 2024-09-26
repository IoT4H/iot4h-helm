{{/*
Expand the name of the chart.
*/}}
{{- define "..name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "..fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "api-public" -}}
{{ include "..fullname" . }}-api-public
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "..chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "..labels-common" -}}
helm.sh/chart: {{ include "..chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}



{{- define "..labels-ui" -}}
{{ include "..labels-common" . }}
{{ include "..selectorLabels-ui" . }}
{{- end }}

{{- define "..labels-api" -}}
{{ include "..labels-common" . }}
{{ include "..selectorLabels-api" . }}
{{- end }}

{{- define "..labels-littlefs" -}}
{{ include "..labels-common" . }}
{{ include "..selectorLabels-littlefs" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "..selectorLabels-common"  -}}
app.kubernetes.io/name: {{ include "..name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "..selectorLabels-api"  -}}
app.kubernetes.io/component: {{ include "..name" . }}-api
{{ include "..selectorLabels-common" . }}
{{- end }}

{{- define "..selectorLabels-littlefs"  -}}
app.kubernetes.io/component: {{ include "..name" . }}-littlefs
{{ include "..selectorLabels-common" . }}
{{- end }}

{{- define "..selectorLabels-ui"  -}}
app.kubernetes.io/component: {{ include "..name" . }}-ui
{{ include "..selectorLabels-common" . }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "..serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "..fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
