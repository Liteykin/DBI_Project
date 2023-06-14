FROM mcr.microsoft.com/dotnet/runtime:7.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["SQL_EFCore Connection/SQL_EFCore Connection.csproj", "SQL_EFCore Connection/"]
RUN dotnet restore "SQL_EFCore Connection/SQL_EFCore Connection.csproj"
COPY . .
WORKDIR "/src/SQL_EFCore Connection"
RUN dotnet build "SQL_EFCore Connection.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "SQL_EFCore Connection.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SQL_EFCore Connection.dll"]
