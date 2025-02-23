const WindStrengthChart = ({ data }) => {
  const chartRef = React.useRef(null);

  React.useEffect(() => {
    if (chartRef.current && window.Chart) {
      const ctx = chartRef.current.getContext('2d');
      const labels = data.map((point) => point.x); // Use 'x' as time
      const yValues = data.map((point) => point.y); // Use 'y' as wind speed

      const getWindColor = (speed) => {
        if (speed < 14) {
          return 'rgba(0, 255, 0, 0.3)';
        }
        if (speed >= 14 && speed <= 19) {
          return 'rgba(255, 255, 0, 0.3)';
        }
        return 'rgba(255, 0, 0, 0.3)';
      };

      const createGradientFill = (context, colorStops) => {
        const gradient = context.createLinearGradient(0, 0, 0, 400);
        colorStops.forEach((stop) => {
          gradient.addColorStop(stop.position, stop.color);
        });
        return gradient;
      };

      const colorStops = yValues.map((speed) => ({
        position: (speed - Math.min(...yValues)) / (Math.max(...yValues) - Math.min(...yValues)),
        color: getWindColor(speed),
      }));

      const gradient = createGradientFill(ctx, colorStops);

      const chartData = {
        labels,
        datasets: [
          {
            label: 'Wind Speed (knots)',
            data: yValues,
            fill: '+1',
            backgroundColor: 'rgba(211, 211, 211, 0.3)',
            borderColor: gradient,
            borderWidth: 8,
            pointRadius: 0,
          },
        ],
      };

      const options = {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          tooltip: {
            enabled: true,
            callbacks: {
              label: (context) => `Wind: ${context.raw} knots`,
            },
          },
          legend: {
            display: false, // Hide the legend
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
              stepSize: 5,
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
    <div style={{ position: 'relative', width: '100%', height: '450px' }}>
      <canvas ref={chartRef}></canvas>
    </div>
  );
};

const App = () => {
  const [data, setData] = React.useState([]);
  const [date, setDate] = React.useState('');

  

  React.useEffect(() => {
    // Fetch the JSON data instead of CSV
    fetch('graph_data.json')
      .then((response) => response.json())
      .then((jsonData) => {
        const parsedData = jsonData.data.map((row) => ({
          x: row.x,
          y: row.y,
        }));
        setData(parsedData);
        setDate(jsonData.metadata.date); // Set the date from metadata
      })
      .catch((error) => {
        console.error("Error loading the JSON data: ", error);
      });
  }, []);

  return (
    <div>
      <h1>{date ? `Wind Data for ${date}` : 'Loading data...'}</h1>  
      {data.length > 0 ? (
        <WindStrengthChart data={data} />
      ) : (
        <p>Loading data...</p>
      )}
    </div>
  );
};

ReactDOM.render(<App />, document.getElementById('root'));
