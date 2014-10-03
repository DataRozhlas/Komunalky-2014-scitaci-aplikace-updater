require! {
  expect: 'expect.js'
  '../src/Serializer.ls'
}
describe "Serializer" (_) ->
  it 'sohuld serialize obce' ->
    out = Serializer.serialize "obce"
    expect out.charCodeAt 0 .to.equal 1

  it 'should serialize senat' ->
    out = Serializer.serialize "senat"
    expect out.charCodeAt 0 .to.equal 2

  it 'should serialize muniIds' ->
    out = Serializer.serialize "500054"
    expect out.charCodeAt 0 .to.equal 10

    out = Serializer.serialize "500097"
    expect out.charCodeAt 0 .to.equal 12

  it 'should serialize JSONs' ->
    data = {foo: "bar", baz: 1}
    out = Serializer.serialize data
    expect out.charCodeAt 0 .to.equal 3
    len = out.charCodeAt 1
    expect out.length .to.be len + 2
    json = out.substr 2
    parsed = JSON.parse json
    expect parsed .to.eql data

  it 'should not fail on unexpected queries' ->
    out = Serializer.serialize "pago"
    expect out .to.be null

