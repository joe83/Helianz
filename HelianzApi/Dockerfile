# syntax=docker/dockerfile:1

# HelianzApi — REST API for the mobile apps (standalone .NET 10, NuGet-only deps).
# Build context = the HelianzApi folder (contains HelianzApi.csproj).

FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY . .
RUN dotnet publish HelianzApi.csproj -c Release -o /app/publish --nologo

FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=build /app/publish .

# Runtime config comes from environment variables (Database__*, Jwt__Key) set in
# the tenant's compose file; these override the baked appsettings.json defaults.
ENV ASPNETCORE_URLS=http://0.0.0.0:8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "HelianzApi.dll"]
