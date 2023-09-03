const diCaprioBirthYear = 1974;
const ageDiCaprio = function(year) { return year - diCaprioBirthYear}
const today = new Date().getFullYear()
const ageToday = ageDiCaprio(today)
console.log(ageToday)

// ----------------------------------------------------------
const width = 800
const height = 600
const margin = {
    top: 50,
    bottom: 50,
    left:50,
    right:50
}  


const svg = d3.select("div#chart").append("svg").attr("width", width).attr("height", height)

const title = svg.append("text")
    .attr("x", margin.left) 
    .attr("y", margin.top / 2)
    .style("font-size", "20px") 
    .style("font-weight", "bold")
    .text("Ejercicio 2 - RGP")

const elementGroup = svg.append("g").attr("class", "elementGroup").attr("transform", `translate(${margin.left},${margin.top})`)

const axisG = svg.append("g").attr("class", "axisG")
const xAxisGroup = axisG.append("g").attr("class", "xAxisGroup").attr("transform", `translate(${margin.left}, ${height - margin.bottom})`)
const yAxisGroup = axisG.append("g").attr("class", "yAxisGroup").attr("transform", `translate(${margin.left}, ${margin.top})`)

//Definición de los ejes: tipo de escala y su rango
const x = d3.scaleBand().range([0, width - margin.left - margin.right]).padding(0.1)
const y = d3.scaleLinear().range([height - margin.top - margin.bottom, 0]);
const yDi = d3.scaleLinear().range([height - margin.bottom - margin.top, 0])


const xAxis = d3.axisBottom().scale(x)  
const yAxis = d3.axisLeft().scale(y)    


d3.csv("data.csv").then(data => {   //se lee el archivo de datos .csv
    // 2. aquí hay que poner el código que requiere datos para generar la gráfica
    data.forEach(d => {
        d.age = +d.age
        d.year = +d.year
    })

    // Configuración del dominio y rango de escalas
    x.domain(data.map(d => d.year)) // Dominio de x configurado para años
    
    // Configurar la escala yDi para la gráfica de líneas
    yDi.domain([0, d3.max(data, d => ageDiCaprio(d.year))])
    
    // Configurar el dominio de la escala Y para representar la edad de DiCaprio
    y.domain([0, ageToday]);

    // Crear ejes
    xAxisGroup.call(xAxis)
    yAxisGroup.call(yAxis)

    const bars = elementGroup.selectAll(".bar").data(data)
    // Definir una escala de colores
    const colorScale = d3.scaleOrdinal()
        .domain(data.map(d => d.name)) // Dominio basado en los valores únicos de la columna "name"
        .range(d3.schemeAccent) // Aquí puedes elegir un esquema de colores, como schemeCategory10


    bars
    .enter()
    .append("rect")
    .attr("class", "bar")
    .attr("x", d => x(d.year))
    .attr("y", d => y(d.age))
    .attr("width", x.bandwidth())
    .attr("height",d => height - margin.bottom - margin.top - y(d.age) - 2)
    .style("fill", d => colorScale(d.name)) // Asignar color basado en la columna "name"
    bars.exit().remove() // Esto es para quitar los elementos que se vayan



    // Crear la línea de edad de DiCaprio
    const line = d3.line()
        .x(d => x(d.year) + x.bandwidth() / 2)
        .y(d => yDi(ageDiCaprio(d.year))) // Usar ageToday como el valor de edad constante

    // Agregar la gráfica de líneas
    elementGroup
    .append("path")
    .datum(data)
    .attr("class", "line")
    .attr("d", line)
        .style("stroke", "red") //se podria poner tamb en el archivo css
        .style("stroke-width", 2)


    // Agregar una etiqueta en cada barra
    const labels = elementGroup.selectAll(".label")
    .data(data)

    labels
    .enter()
    .append("text")
    .attr("class", "label")
    .text(d => d.age)
    .attr("x", d => x(d.year) + x.bandwidth() / 4)
    .attr("y", d => y(d.age) - 10) //Etiqueta justo encima de la barra

    labels.exit().remove()
})


//Leyenda debajo del eje horizontal
svg.append("text")
    .attr("x", width / 2)
    .attr("y", height - 10)
    .style("text-anchor", "middle")
    .text("Edad de Leonardo Di Caprio (Linea) y de sus exs (Barras).")

