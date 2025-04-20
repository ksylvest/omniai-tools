# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.4.2
FROM docker.io/library/ruby:${RUBY_VERSION}-slim AS base

WORKDIR /project

COPY ./project/Gemfile* ./

RUN bundle install
