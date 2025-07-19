# WindAI

WindAI is a web application that visualizes wind data and provides a simple interface to test backend Python Lambda functions via AWS API Gateway. The project uses a static website hosted on AWS S3, with infrastructure managed by Terraform.

## Features

- **Wind Data Visualization:**  
  Interactive wind speed charts using React and Chart.js, with data loaded from a JSON file.

- **Backend Test Interface:**  
  A form to send text input to a Python Lambda function via API Gateway and display the response.

- **Animated Waves Background:**  
  SVG-based animated waves for a visually appealing background.

- **About Page:**  
  Simple profile/about section.

## Project Structure

```
WindAI/
│
├── front_end/
│   ├── index.html         # Main landing page
│   ├── wind.html          # Wind data visualization page
│   ├── test.html          # Backend test page
│   ├── about.html         # About/profile page
│   ├── index.js           # JS for navigation and waves loading
│   ├── wind.js            # React code for wind chart
│   ├── test.js            # JS for backend test form/API call
│   ├── waves.html         # SVG markup for animated waves
│   └── public/
│       └── styles/
│           ├── styles.css # Main styles
│           ├── wind.css   # Wind page styles
│           └── waves.css  # Waves background styles
│
├── infra/
│   ├── api.tf             # Terraform: API Gateway and Lambda resources
│   ├── lambda.tf          # Terraform: Lambda function and IAM roles
│   ├── s3.tf              # Terraform: S3 static website and objects
│   ├── notes.txt          # Infra notes and snippets
│   └── api_id.txt         # API Gateway ID (generated)
│
└── backend/
    └── lambda1.py         # Python Lambda function (referenced in infra)
```

## How It Works

- **Frontend:**  
  - `index.html` is the entry point, with navigation to wind data, backend test, and about pages.
  - `wind.html` loads wind data from `graph_data.json` and renders a chart using React and Chart.js.
  - `test.html` allows users to submit text to a Lambda backend and see the response.
  - Animated SVG waves are loaded into the background for visual effect.

- **Backend:**  
  - Python Lambda function (see `backend/lambda1.py`) processes requests from the frontend.
  - API Gateway exposes the Lambda via a REST endpoint.
  - The API Gateway ID is written to `api_id.txt` and uploaded to S3 for the frontend to fetch dynamically.

- **Infrastructure:**  
  - Terraform scripts in `infra/` provision S3, API Gateway, Lambda, and related resources.
  - Static assets are uploaded to the S3 bucket and served as a website.

## Deployment

1. **Infrastructure:**  
   Use Terraform to deploy resources in `infra/`. This sets up S3, API Gateway, Lambda, and uploads static files.

2. **Frontend:**  
   All frontend files are served from the S3 static website.

3. **Backend:**  
   Lambda function is packaged and deployed via Terraform.

## Customization

- To update the backend logic, edit `backend/lambda1.py` and re-deploy.
- To change the frontend, edit files in `front_end/` and re-upload via Terraform.

## Requirements

- AWS account with S3, Lambda, and API Gateway permissions
- Terraform
- Node.js (for local development, if needed)

---

**Note:**  
- The API Gateway ID is dynamically fetched by the frontend from `api_id.txt` in the S3 bucket.
- For more details, see comments in the Terraform files