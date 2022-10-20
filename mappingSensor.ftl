<#assign jpath=handlers("JsonHandler")>
<#assign dataset=providers("FileProvider", { "file" : "mappingSensor.json" })>
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

ex:mod/[=jpath.filter('$.mod_id', dataset)]
    a saref:Device ;
    sensor:hasPointGeometry ex:point/[=jpath.filter('$.mod_id', dataset)]_[=jpath.filter('$.mac', dataset)] .
ex:point/[=jpath.filter('$.mod_id', dataset)]_[=jpath.filter('$.mac', dataset)]
    a geo:Point ;
    geo:hasSerialization "Point([=jpath.filter('$.lat', dataset)] [=jpath.filter('$.long', dataset)])"^^<http://www.opengis.net/ont/geosparql#wktLiteral> .
<#list jpath.filter('$.sensors', dataset) as sensors>
    ex:sensor/[=jpath.filter('$.model', sensors)]
        a saref:Sensor ;
        saref:consistsOf ex:mod/[=jpath.filter('$.mod_id', dataset)] ;
        saref:makesMeasurement ex:measurement/[...] .
    ex:measurement/[...]
        a saref:Measurement ;
        saref:hasTimeStamp "[=jpath.filter('$.time', sensors)]"^^xsd:dateTime ;
        saref:hasValue "[=jpath.filter('$.value', sensors)]"^^xsd:double ;
        saref:isMeasuredIn [=jpath.filter('$.unit_of_measure', sensors)] ;
        saref:relatesToProperty sensor:"[=jpath.filter('$.measure_property', sensors)]" .
    [=jpath.filter('$.unit_of_measure', sensors)]
        a saref:UnitOfMeasure .
</#list>
