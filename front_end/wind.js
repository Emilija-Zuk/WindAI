const WindStrengthChart = ({ data }) => {


  const chartRef = React.useRef(null);

  React.useEffect(() => {
    if (chartRef.current && window.Chart) {
      const ctx = chartRef.current.getContext('2d');
      const labels = data.map((point) => point.time);
      const minWind = data.map((point) => point.min);
      const maxWind = data.map((point) => point.max);

      const getWindColor = (speed) => {
          // console.log('Wind speed:', speed);  
          if (speed < 14) {
            return 'rgba(0, 255, 0, 0.3)'; // Red for < 14 knots rgba(255, 0, 0, 0.3)
          }
          if (speed >= 14 && speed <= 19) {
            return 'rgba(255, 255, 0, 0.3)'; // Yellow for 14-19 knots
          }
          return 'rgba(255, 0, 0, 0.3)'; // Green for >= 20 knots rgba(0, 255, 0, 0.3)
      };

      const createGradientFill = (context, colorStops) => {
          const gradient = context.createLinearGradient(0, 0, 0, 400);
          colorStops.forEach((stop, index) => {
          gradient.addColorStop(stop.position, stop.color);
          });
          return gradient;
      };

      const colorStopsMin = minWind.map((speed) => ({
          position: (speed - Math.min(...minWind)) / (Math.max(...minWind) - Math.min(...minWind)),
          color: getWindColor(speed),
      }));

      const gradientMin = createGradientFill(ctx, colorStopsMin);

      const chartData = {
        labels,
        datasets: [
          {
            label: 'Min Wind Speed (knots)',
            data: minWind,
            fill: '+1',   
            backgroundColor: 'rgba(211, 211, 211, 0.3)',  
            borderColor: gradientMin, 
            borderWidth: 8,
            pointRadius: 0, 
            
          },
          {
            label: 'Max Wind Speed Gust (knots)',
            data: maxWind,
            fill: '+1',  
            backgroundColor: 'rgba(211, 211, 211, 0.3)',  
            borderColor: 'rgba(211, 211, 211, 0.3)',
            pointRadius: 0, 
            
          },
        ],
      };
  
      const options = {
        responsive: true,
        maintainAspectRatio: false, // custom height for the chart
        plugins: {
          tooltip: {
            enabled: true,
            callbacks: {
              label: (context) => `Wind: ${context.raw} knots`,
            },
          },
          legend: {
            // display: false, // Hide the legend
          },
        },
        scales: {
          x: {
            title: { display: true, text: 'Time' },
          },
          y: {
            title: { display: true, text: 'Wind Speed (knots)' },
            min: 0, 
            max: 30, 
            ticks: {
              stepSize: 5, // Step size between ticks on the Y-axis
            },
          },
        },
      };
  
        
      new window.Chart(ctx, {
        type: 'line',
        data: chartData,
        options: options,
      });

    }
  }, [data]);
  
  return (
    <div style={{ position: 'relative', width: '100%', height: '450px' }}> {/* size */}
      <canvas ref={chartRef}></canvas>
    </div>
  );
};
  
const App = () => {

  const [data, setData] = React.useState([]);

  React.useEffect(() => {
    Papa.parse('wind_data.csv', {
      download: true,
      header: true,
      complete: (results) => {
        const parsedData = results.data
          .map((row) => ({
            time: row.time,
            min: Number(row.min),
            max: Number(row.max),
          }))
          .filter((row) => row.time && row.min && row.max);
        setData(parsedData);
      },
    });
  }, []);

  return (
    <div>
      <h1>Yesterday's Wind</h1>
      {data.length > 0 ? (
        <WindStrengthChart data={data} />
      ) : (
        <p>Loading data...</p>
      )}
    </div>
  );
};
  
 
ReactDOM.render(<App />, document.getElementById('root'));
  