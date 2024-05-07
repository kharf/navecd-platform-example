// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go github.com/prometheus-operator/prometheus-operator/pkg/apis/monitoring/v1

package v1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/api/core/v1"
)

#ProbesKind:   "Probe"
#ProbeName:    "probes"
#ProbeKindKey: "probe"

// Probe defines monitoring for a set of static targets or ingresses.
#Probe: {
	metav1.#TypeMeta
	metadata?: metav1.#ObjectMeta @go(ObjectMeta)

	// Specification of desired Ingress selection for target discovery by Prometheus.
	spec: #ProbeSpec @go(Spec)
}

// ProbeSpec contains specification parameters for a Probe.
// +k8s:openapi-gen=true
#ProbeSpec: {
	// The job name assigned to scraped metrics by default.
	jobName?: string @go(JobName)

	// Specification for the prober to use for probing targets.
	// The prober.URL parameter is required. Targets cannot be probed if left empty.
	prober?: #ProberSpec @go(ProberSpec)

	// The module to use for probing specifying how to probe the target.
	// Example module configuring in the blackbox exporter:
	// https://github.com/prometheus/blackbox_exporter/blob/master/example.yml
	module?: string @go(Module)

	// Targets defines a set of static or dynamically discovered targets to probe.
	targets?: #ProbeTargets @go(Targets)

	// Interval at which targets are probed using the configured prober.
	// If not specified Prometheus' global scrape interval is used.
	interval?: #Duration @go(Interval)

	// Timeout for scraping metrics from the Prometheus exporter.
	// If not specified, the Prometheus global scrape timeout is used.
	scrapeTimeout?: #Duration @go(ScrapeTimeout)

	// TLS configuration to use when scraping the endpoint.
	tlsConfig?: null | #SafeTLSConfig @go(TLSConfig,*SafeTLSConfig)

	// Secret to mount to read bearer token for scraping targets. The secret
	// needs to be in the same namespace as the probe and accessible by
	// the Prometheus Operator.
	bearerTokenSecret?: v1.#SecretKeySelector @go(BearerTokenSecret)

	// BasicAuth allow an endpoint to authenticate over basic authentication.
	// More info: https://prometheus.io/docs/operating/configuration/#endpoint
	basicAuth?: null | #BasicAuth @go(BasicAuth,*BasicAuth)

	// OAuth2 for the URL. Only valid in Prometheus versions 2.27.0 and newer.
	oauth2?: null | #OAuth2 @go(OAuth2,*OAuth2)

	// MetricRelabelConfigs to apply to samples before ingestion.
	metricRelabelings?: [...null | #RelabelConfig] @go(MetricRelabelConfigs,[]*RelabelConfig)

	// Authorization section for this endpoint
	authorization?: null | #SafeAuthorization @go(Authorization,*SafeAuthorization)

	// SampleLimit defines per-scrape limit on number of scraped samples that will be accepted.
	// +optional
	sampleLimit?: null | uint64 @go(SampleLimit,*uint64)

	// TargetLimit defines a limit on the number of scraped targets that will be accepted.
	// +optional
	targetLimit?: null | uint64 @go(TargetLimit,*uint64)

	// `scrapeProtocols` defines the protocols to negotiate during a scrape. It tells clients the
	// protocols supported by Prometheus in order of preference (from most to least preferred).
	//
	// If unset, Prometheus uses its default value.
	//
	// It requires Prometheus >= v2.49.0.
	//
	// +listType=set
	// +optional
	scrapeProtocols?: [...#ScrapeProtocol] @go(ScrapeProtocols,[]ScrapeProtocol)

	// Per-scrape limit on number of labels that will be accepted for a sample.
	// Only valid in Prometheus versions 2.27.0 and newer.
	// +optional
	labelLimit?: null | uint64 @go(LabelLimit,*uint64)

	// Per-scrape limit on length of labels name that will be accepted for a sample.
	// Only valid in Prometheus versions 2.27.0 and newer.
	// +optional
	labelNameLengthLimit?: null | uint64 @go(LabelNameLengthLimit,*uint64)

	// Per-scrape limit on length of labels value that will be accepted for a sample.
	// Only valid in Prometheus versions 2.27.0 and newer.
	// +optional
	labelValueLengthLimit?: null | uint64 @go(LabelValueLengthLimit,*uint64)

	// Per-scrape limit on the number of targets dropped by relabeling
	// that will be kept in memory. 0 means no limit.
	//
	// It requires Prometheus >= v2.47.0.
	//
	// +optional
	keepDroppedTargets?: null | uint64 @go(KeepDroppedTargets,*uint64)

	// The scrape class to apply.
	// +optional
	// +kubebuilder:validation:MinLength=1
	scrapeClass?: null | string @go(ScrapeClassName,*string)
}

// ProbeTargets defines how to discover the probed targets.
// One of the `staticConfig` or `ingress` must be defined.
// If both are defined, `staticConfig` takes precedence.
// +k8s:openapi-gen=true
#ProbeTargets: {
	// staticConfig defines the static list of targets to probe and the
	// relabeling configuration.
	// If `ingress` is also defined, `staticConfig` takes precedence.
	// More info: https://prometheus.io/docs/prometheus/latest/configuration/configuration/#static_config.
	staticConfig?: null | #ProbeTargetStaticConfig @go(StaticConfig,*ProbeTargetStaticConfig)

	// ingress defines the Ingress objects to probe and the relabeling
	// configuration.
	// If `staticConfig` is also defined, `staticConfig` takes precedence.
	ingress?: null | #ProbeTargetIngress @go(Ingress,*ProbeTargetIngress)
}

// ProbeTargetStaticConfig defines the set of static targets considered for probing.
// +k8s:openapi-gen=true
#ProbeTargetStaticConfig: {
	// The list of hosts to probe.
	static?: [...string] @go(Targets,[]string)

	// Labels assigned to all metrics scraped from the targets.
	labels?: {[string]: string} @go(Labels,map[string]string)

	// RelabelConfigs to apply to the label set of the targets before it gets
	// scraped.
	// More info: https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config
	relabelingConfigs?: [...null | #RelabelConfig] @go(RelabelConfigs,[]*RelabelConfig)
}

// ProbeTargetIngress defines the set of Ingress objects considered for probing.
// The operator configures a target for each host/path combination of each ingress object.
// +k8s:openapi-gen=true
#ProbeTargetIngress: {
	// Selector to select the Ingress objects.
	selector?: metav1.#LabelSelector @go(Selector)

	// From which namespaces to select Ingress objects.
	namespaceSelector?: #NamespaceSelector @go(NamespaceSelector)

	// RelabelConfigs to apply to the label set of the target before it gets
	// scraped.
	// The original ingress address is available via the
	// `__tmp_prometheus_ingress_address` label. It can be used to customize the
	// probed URL.
	// The original scrape job's name is available via the `__tmp_prometheus_job_name` label.
	// More info: https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config
	relabelingConfigs?: [...null | #RelabelConfig] @go(RelabelConfigs,[]*RelabelConfig)
}

// ProberSpec contains specification parameters for the Prober used for probing.
// +k8s:openapi-gen=true
#ProberSpec: {
	// Mandatory URL of the prober.
	url: string @go(URL)

	// HTTP scheme to use for scraping.
	// `http` and `https` are the expected values unless you rewrite the `__scheme__` label via relabeling.
	// If empty, Prometheus uses the default value `http`.
	// +kubebuilder:validation:Enum=http;https
	scheme?: string @go(Scheme)

	// Path to collect metrics from.
	// Defaults to `/probe`.
	// +kubebuilder:default:="/probe"
	path?: string @go(Path)

	// Optional ProxyURL.
	proxyUrl?: string @go(ProxyURL)
}

// ProbeList is a list of Probes.
// +k8s:openapi-gen=true
#ProbeList: {
	metav1.#TypeMeta

	// Standard list metadata
	// More info: https://github.com/kubernetes/community/blob/master/contributors/devel/sig-architecture/api-conventions.md#metadata
	metadata?: metav1.#ListMeta @go(ListMeta)

	// List of Probes
	items: [...null | #Probe] @go(Items,[]*Probe)
}
