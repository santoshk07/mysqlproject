FROM microsoft/aspnetcore:2.0 AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/aspnetcore-build:2.0 AS build
WORKDIR /src
COPY ["mysqltestproject/mysqltestproject.csproj", "mysqltestproject/"]
RUN dotnet restore "mysqltestproject/mysqltestproject.csproj"
COPY . .
WORKDIR "/src/mysqltestproject"
RUN dotnet build "mysqltestproject.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "mysqltestproject.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "mysqltestproject.dll"]

