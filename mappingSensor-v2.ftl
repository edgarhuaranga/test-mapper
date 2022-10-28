<#assign jpath=handlers("JsonHandler")>
<#assign dataset=providers("URLProvider", { "url" : "https://raw.githubusercontent.com/Salva5297/RpiSensor/main/Examples/example.json?token=GHSAT0AAAAAABZCVGZGXDP3KK7CICDURW6UY2SO6IQ" })>
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
@prefix owl: <http://www.w3.org/2002/07/owl#> .
@prefix geo: <http://www.opengis.net/ont/geosparq#> .
@prefix time: <http://www.w3.org/2006/time#> .
@prefix om: <http://www.ontology-of-units-of-measure.org/resource/om-2/> .
@prefix saref: <https://saref.etsi.org/core/> .
@prefix sensor: <https://sensorize.iot.linkeddata.es/def/>
@prefix ex: <https://data.example.iot.linkeddata.es/resources> .
ex:mod/[=jpath.filter('$.Metadata.mod_id', dataset)]_[=jpath.filter('$.Metadata.mac', dataset)]
    a saref:Device ;
    sensor:hasPointGeometry ex:point/[=jpath.filter('$.Metadata.mod_id', dataset)]_[=jpath.filter('$.Metadata.mac', dataset)] .
ex:point/[=jpath.filter('$.Metadata.mod_id', dataset)]_[=jpath.filter('$.Metadata.mac', dataset)]
    a geo:Point ;
    geo:hasSerialization "Point([=jpath.filter('$.Location.lat', dataset)] [=jpath.filter('$.Location.lon', dataset)])"^^<http://www.opengis.net/ont/geosparql#wktLiteral> .
<#list jpath.filter('$.Sensors', dataset) as sensors>
    ex:sensor/[=jpath.filter('$.model', sensors)]
        a saref:Sensor ;
        saref:consistsOf ex:mod/[=jpath.filter('$.Metadata.mod_id', dataset)]_[=jpath.filter('$.Metadata.mac', dataset)] ;
        saref:makesMeasurement ex:measurement/[=jpath.filter('$.measure_property', sensors)].
    ex:measurement/[=jpath.filter('$.measure_property', sensors)]
        a saref:Measurement ;
        saref:hasTimeStamp "[=jpath.filter('$.Time.timeStamp', sensors)]"^^xsd:dateTime ;
        saref:hasValue [=jpath.filter('$.value', sensors)]^^xsd:float ;
        saref:isMeasuredIn [=jpath.filter('$.unit_of_measure', sensors)] ;
        saref:relatesToProperty sensor:[=jpath.filter('$.measure_property', sensors)] .
    [=jpath.filter('$.unit_of_measure', sensors)]
        a saref:UnitOfMeasure .
</#list>