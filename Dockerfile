# Use the latest .NET 6 SDK image as the base
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env

# Set the working directory
WORKDIR /app

# Copy the project files
COPY . ./

# Restore the NuGet packages
RUN dotnet restore

# Build the project
RUN dotnet publish -c Release -o out

# Use the latest .NET 6 runtime image as the base
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

# Set the working directory
WORKDIR /app

# Copy the published output from the build stage
COPY --from=build-env /app/out .

# Expose the port the application is running on
EXPOSE 80
EXPOSE 443

# Set the command to start the application
ENTRYPOINT ["dotnet", "BookStoreApi.dll"]

# Run the MongoDB container
FROM mongo:latest