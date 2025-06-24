# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Setup and Dependencies
- `mix setup` - Install dependencies, create database, run migrations, setup assets
- `mix deps.get` - Install dependencies only

### Running the Application
- `mix phx.server` - Start Phoenix server at localhost:4000
- `iex -S mix phx.server` - Start server with interactive Elixir shell

### Database Operations
- `mix ecto.create` - Create database
- `mix ecto.migrate` - Run migrations
- `mix ecto.rollback` - Rollback migrations
- `mix ecto.reset` - Drop and recreate database with fresh data

### Code Quality
- `mix credo` - Run static code analysis (available in dev/test environments)
- `mix test` - Run test suite (automatically creates test database)

### Asset Management
- `mix assets.build` - Build CSS/JS assets
- `mix assets.deploy` - Build and minify assets for production

## Architecture Overview

### Application Structure
This is a Phoenix LiveView application that integrates with Spotify's Web API for music discovery and playlist management. The application follows Phoenix's context pattern with clear separation between business logic and web interface.

### Key Contexts
- **Accounts** (`lib/spotify_re_discoverer/accounts.ex`) - User authentication and management
- **Spotify** (`lib/spotify_re_discoverer/spotify/`) - Spotify API integration and OAuth handling

### Database Schema
- **Users**: Standard Phoenix authentication with email/password (uses bcrypt)
- **Spotify Credentials**: OAuth tokens (access_token, refresh_token, expires_in)
- **Spotify Users**: Spotify profile data linked to internal user accounts

### Web Interface
- **DashboardLive** - Main authenticated user interface showing playlists
- **Authentication LiveViews** - Registration, login, password reset flows
- **ConnectSpotifyButton** - Component for Spotify OAuth integration

### Spotify Integration
- OAuth 2.0 flow with comprehensive scopes for playlist modification and user data
- Automatic token refresh mechanism
- Recursive playlist fetching for users with large libraries
- HTTP client using Req library for API calls

### Key Files
- `lib/spotify_re_discoverer/spotify/client.ex` - Main Spotify API client
- `lib/spotify_re_discoverer_web/router.ex` - Route definitions and pipelines
- `lib/spotify_re_discoverer_web/user_auth.ex` - Authentication plugs and helpers

### Configuration
- Environment variables required: Spotify client credentials, database URL
- Production deployment configured for Fly.io
- Admin dashboard protected with basic auth in production (AUTH_USERNAME, AUTH_PASSWORD)
- Sentry integration for error tracking

### Development Notes
- Uses Tailwind CSS for styling
- LiveView for real-time user interactions
- PostgreSQL database with Ecto ORM
- Binary UUID primary keys for users
- CSRF protection enabled on all browser routes

## Project Purpose & Feature Roadmap

This application helps Spotify users rediscover forgotten music from their library. Currently implements basic user authentication and playlist viewing, with core re-discovery features planned.

### High Priority Features
- **Listening History Analysis** - Identify forgotten favorites using Spotify's recently played API
- **Old Songs Detector** - Find songs in playlists that haven't been played recently

### Medium Priority Features  
- **Auto Throwback Playlists** - Generate playlists based on listening history patterns
- **Similar Song Discovery** - Recommend similar tracks to old favorites
- **Listening Timeline** - Visualize listening habits and music taste evolution

### Lower Priority Features
- **Playlist Archaeology** - Analyze when songs were added vs last played
- **Mood/Genre Analysis** - Identify forgotten musical phases through pattern analysis
- **Rediscovery Notifications** - Periodic suggestions of forgotten songs