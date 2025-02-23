import json
import datetime

print("hello em")

with open('GC2025-02-21.json', 'r') as file:
    data = json.load(file)

# value_x = data["observationalGraphs"]["wind"]["dataConfig"]["series"]["groups"][0]["points"][n]["x"]

points = data["observationalGraphs"]["wind"]["dataConfig"]["series"]["groups"][0]["points"]
graph_data = []


for point in points:
    x_value = point["x"]
    dt_object = datetime.datetime.fromtimestamp(x_value, tz=datetime.timezone.utc)
    x_value = dt_object.strftime("%H:%M")

    y_value = point["y"]
    y_value = y_value * 0.539957

    graph_data.append({"x": x_value, "y": y_value})

final_output = {
    "metadata": {
        "title": "Wind Strength Over Time",
        "unit": "knots",
        "date": "21 February 2025"
    },
    "data": graph_data
}


with open("graph_data.json", "w") as outfile:
    json.dump(final_output, outfile, indent=4)






# timestamp = value_x
# dt_object = datetime.datetime.fromtimestamp(timestamp, tz=datetime.timezone.utc)
# time_only = dt_object.strftime("%H:%M:%S")

