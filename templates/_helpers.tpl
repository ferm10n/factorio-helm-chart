{{- define "factorio.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
{{- end -}}

{{- define "factorio.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "factorio.image" -}}
{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}
{{- end -}}

{{- define "factorio.name" -}}
{{ .Chart.Name }}
{{- end -}}

{{- define "factorio.pvcName" -}}
{{- if .Values.factorio.persistence.pvcName -}}
    {{ .Values.factorio.persistence.pvcName }}
{{- else -}}
    {{ include "factorio.fullname" . }}-pvc
{{- end -}}
{{- end -}}