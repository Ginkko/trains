#Train-O-Rama
<h2>Authors:</h2>
Alec Arme and Brent Bailey

<h2>Description:</h2>
This app allows employees of a train company to add, update, and delete train lines and cities. It also allows users to see lists of stops for each train and trains that visit each stops. Future upgrades will include a timetable for each stop and ticketing functionality for each line, so users can buy a single ticket and go anywhere on that line.

<h2>Setup instructions:</h2>
Bundle to install the gems in the Gemfile. Database structure for this app requires postgres, with the following structure: a train table with a unique id (PRIMARY KEY) and name for all trains, the same for cities, and a join table that takes train ids, city ids, and a time (saved as a string).

Table Trains:

id  | name
------------- | -------------
1  | Blue Line
2  | Yellow Line


Table Cities:

id  | name
------------- | -------------
1  | Portland
2  | Jaynestown

Stops Table:

id  | train_id | city_id| time
--- | ------- | ------------- | -----
1  | 1 | 2 | 7:00
2  | 2 | 1 | 8:00


Copyright: MIT License 2015
