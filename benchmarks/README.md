# Benchmarks

The COOM Suite contains the following four benchmark sets.

## Core

- Benchmark set corresponding to the **COOM Core** language
- Makes use of multi-valued attributes and randomized table constraints
- Scalable factor is the number of attributes and values

## City Bike Fleet

- Benchmark set corresponding to the **COOM[P]** language
- A fleet of bikes where each bike is based on the City Bike
- Makes use of partonomy but has no numeric values
- Scalable factor is the number of bikes in the fleet

## Travel Bike Fleet

- Benchmark set corresponding to the **COOM[X]** language
- A fleet of bikes where each bike is based on the \\travelbike
- Makes use of partonomy as well as numeric values and aggregations
- Scalable factor is the number of bikes and the price for all bikes in the
  fleet maximum

## Restaurant

- Benchmark set corresponding to the **COOM[X]** language
- Configuring a fixed number of chairs assigned to tables of different sizes
- Makes use of partonomy as well as simple numeric constraints
- Scalable factor is the total number of tables and the number of chairs to be
  assigned
