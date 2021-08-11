# Changelog

Изменения этого проекта представленны здесь.

Формат лога сделан согласно этому проекту [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
и соглано этому тоже [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added 

- добавленные изменения

### Fixed

- исправление ошибок

[0.0.6] - 2021-08-10

### Added

- Добавлено prod окружение kubernetes [geckonoff] (https://github.com/geckonoff)
- Добавлен мониторинг кластера и приложения [geckonoff] (https://github.com/geckonoff)
- Добавлено логирование EFK [geckonoff] (https://github.com/geckonoff)
- Добавлено dev окружение, кластер kubernetes, платформа YandexCloud [mzabolotnov] (https://github.com/mzabolotnov)
- Добавлены пайплайны деплоя приложения crawler в dev и prod окружения из helm чартов  [mzabolotnov] (https://github.com/mzabolotnov)
- Добавлен мониторинг кластера и приложения в dev окружении mzabolotnov] (https://github.com/mzabolotnov)

[0.0.5] - 2021-08-03

### Added

- Добавлена ветка с развертыванием кластера k8s в yc от [geckonoff] (https://github.com/geckonoff)
- Добавлены пайплайны сборки образов Docker приложения crawler [mzabolotnov] (https://github.com/mzabolotnov)
- Приложение переведено на образы на основе Alpine Linux

[0.0.4] - 2021-07-15

### Added

- Добавлен старт проекта с помощью terraform и ansible от [geckonoff] (https://github.com/geckonoff)
- Добавлен пайплайн для тестов приложения crawler [mzabolotnov] (https://github.com/mzabolotnov)
- Добавлен пайплайн проверки кода terraform [mzabolotnov] (https://github.com/mzabolotnov)

[0.0.3] - 2021-07-09

### Added

- Добавлен запуск GitLab от [geckonoff] (https://github.com/geckonoff)

[0.0.2] - 2021-07-08

### Fixed

- Исправлен запуст приложения целиком crawler+ui [mzabolotnov] (https://github.com/mzabolotnov)

### Added

- Добавлен запуск системы мониторинга prometheus + node-exporter + cadvisor [mzabolotnov] (https://github.com/mzabolotnov)


[0.0.1] - 2021-07-06
### Added
Добавлен терраформ от ivkosarev (https://github.com/ivkosarev/)


### Added 


- Добавлен запуск crawler от [geckonoff] (https://github.com/geckonoff)

### Added

- Добавлен запуск ui от [mzabolotnov] (https://github.com/mzabolotnov)
