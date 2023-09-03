// CHART START

// 1. aquí hay que poner el código que genera la gráfica

const width = 800
const height = 600
const margin = {
    top: 50,
    bottom: 50,
    left:80,
    right:50
}  
const svg = d3.select("div#chart").append("svg").attr("width", width).attr("height", height)

const title = svg.append("text")
    .attr("x", margin.left) // Posición en el centro horizontal del SVG
    .attr("y", margin.top / 2) // Posición en la parte superior del SVG, ajusta según tus necesidades
    .style("font-size", "20px") // Tamaño de fuente
    .style("font-weight", "bold") // Peso de la fuente
    .text("Ejercicio 1 - RGP"); // Tu título aquí

const elementGroup = svg.append("g").attr("class", "elementGroup").attr("transform", `translate(${margin.left},${margin.top})`)

const axisG = svg.append("g").attr("class", "axisG")
const xAxisGroup = axisG.append("g").attr("class", "xAxisGroup").attr("transform", `translate(${margin.left}, ${height - margin.bottom})`)
const yAxisGroup = axisG.append("g").attr("class", "yAxisGroup").attr("transform", `translate(${margin.left}, ${margin.top})`)

//Definición de los ejes: tipo de escala y su rango
const y = d3.scaleBand().range([0, height - margin.right - margin.top]).padding(0.1)
const x = d3.scaleLinear().range([ 0, height - margin.top - margin.bottom])
        //datos discretos, por eso es scaleBand. el padding es el margen entre los grupos


const xAxis = d3.axisBottom().scale(x)    //para el eje horizontal, se le pone la escala que hemos calculado
const yAxis = d3.axisLeft().scale(y)    // para el eje vertical

let years;
let winners;
let originalData;

d3.csv("WorldCup.csv").then(data =>{   //se lee el archivo de datos .csv
    // 2. aquí hay que poner el código que requiere datos para generar la gráfica
    
    
    data.map(d => {  //esto es para cambiar el tipo de dato, en este caso tenemos los numeros como string, y los queremos en formato numero
        d.Year = +d.Year
    })
    years = data.map(d => d.Year) //se rellena el array que se instanció antes, solo con los datos de la columna Years
    originalData = data

    y.domain(calculate_winners(data.map(d=>d.Winner)))
    x.domain([0, max_value(data)]) 
    xAxis.ticks(max_value(data))
    console.log(data)
    // update:
    update(data)
    slider()
})


function max_value(data){ //función en la que se calcula el valor maximo
    const sum_winners = data.map(d => d.Winner)  // añadimos a este array los paises de los datos FILTRADOS 
    return d3.max(sum_winners, d => sum_winners.filter(item => item === d).length)
}


function calculate_winners(data){
    return [...new Set(data)]
}

// update:
function update(data) {
    // 3. función que actualiza el gráfico
    winners = data.map(d => d.Winner)
    xAxisGroup.call(xAxis)
    yAxisGroup.call(yAxis)


    const elements = elementGroup.selectAll("rect").data(winners)
    elements.enter()
        .append("rect")
        .attr("class", d => `${d} bar`)
        .attr("x", 10)
        .attr("y", d => y(d))
        .attr("height", y.bandwidth())
        .attr("width", d =>  x((winners.filter(item => item === d).length)))
    
    elements
        .attr("x", 10)
        .attr("height", y.bandwidth())
        .attr("y", d => y(d))  
        .attr("width", d =>  x(winners.filter(item => item === d).length))

    elements.exit() 
        .remove()//esto es para quitar los elementos que se vayan
    
    
}


// treat data:
function filterDataByYear(year) { 
    // 4. función que filtra los datos dependiendo del año que le pasemos (year)
    filtered_data =  originalData.filter(d => d.Year <= year) //filtro menos o igual que el dato de year que se introduce desde el slide
    update(filtered_data)
    d3.select('p#value-time').text('Mundiales ganados hasta ' + year);
}


function slider() {
    var sliderTime = d3
        .sliderBottom()
        .min(d3.min(years))
        .max(d3.max(years))
        .step(4)
        .width(580)
        .ticks(years.length)
        .default(years[years.length - 1])
        .on('onchange', val => {
            filterDataByYear(val);
        });

    // Contenedor del slider
    var gTime = d3
        .select('div#slider-time')
        .append('svg')
        .attr('width', width - margin.left - margin.right)
        .attr('height', 100) // Altura del slider
        .append('g')
        .attr('class', 'slider')
        .attr('transform', 'translate(30,30)');

    gTime.call(sliderTime);
}

