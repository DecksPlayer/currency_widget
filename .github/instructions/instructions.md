# Currency Widget - Instrucciones para AI Agents

Este documento proporciona instrucciones técnicas para agentes de IA que trabajen en el desarrollo, mantenimiento y extensión del paquete `currency_widget`.

## 📋 Descripción del Proyecto

**Currency Widget** es un paquete Flutter que proporciona una colección de widgets especializados para el manejo de monedas en aplicaciones. El paquete simplifica la selección de monedas, la entrada de valores monetarios con formato automático, y la visualización de cantidades en diferentes monedas.

### Propósito
- Facilitar la implementación de funcionalidades relacionadas con monedas en apps Flutter
- Proporcionar formateo automático según las reglas específicas de cada moneda
- Ofrecer una experiencia de usuario consistente para inputs y displays monetarios
- Soportar múltiples idiomas y más de 150 monedas internacionales

### Casos de Uso
- Aplicaciones de finanzas personales
- E-commerce y sistemas de pago
- Conversores de moneda
- Reportes financieros y dashboards
- Presupuestos y calculadoras

---

## 🏗️ Arquitectura del Proyecto

### Patrón Arquitectónico: **Controller Pattern + State Management**

El paquete utiliza una arquitectura basada en controladores con gestión de estado reactiva mediante `ValueNotifier`. Esta arquitectura permite separación de responsabilidades y reactividad eficiente.

#### Componentes Arquitectónicos:

```
currency_widget/
├── lib/
│   ├── currency_widget.dart           # Punto de entrada (barrel file)
│   └── src/
│       ├── models/                     # Capa de Modelos
│       │   └── currency.dart           # Modelo de datos Currency
│       │
│       ├── Controller/                 # Capa de Controladores
│       │   └── currency_controller.dart # Gestor de estado central
│       │
│       ├── view/                       # Capa de Presentación
│       │   ├── currency_picker.dart    # Widget de selección
│       │   ├── currency_textfield.dart # Widget de entrada
│       │   ├── currency_textview.dart  # Widget de visualización
│       │   └── currency_card_view_report.dart # Widget de reporte
│       │
│       ├── utils/                      # Capa de Utilidades
│       │   ├── masked_text_editing_controller.dart # Formatter
│       │   ├── currency_decoration.dart # Decoración UI
│       │   └── currency_errors.dart    # Mensajes de error
│       │
│       └── assets/                     # Capa de Datos
│           ├── supported_currencies.dart # Lista de monedas
│           └── currencies_names/       # Traducciones
│
└── example/                            # App de ejemplo
```

### Descripción de Capas

#### 1. **Capa de Modelos** (`models/`)
- **Responsabilidad**: Definición de estructuras de datos
- **Componentes**:
  - `Currency`: Modelo inmutable que representa una moneda con sus propiedades (código, símbolo, decimales, etc.)
- **Patrón**: Data Transfer Object (DTO)

#### 2. **Capa de Controladores** (`Controller/`)
- **Responsabilidad**: Gestión de estado y lógica de negocio
- **Componentes**:
  - `CurrencyController`: Controlador central que gestiona:
    - Selección de moneda actual
    - Valor del monto ingresado
    - Notificación de cambios a la UI
    - Operaciones sobre monedas (búsqueda por código)
- **Patrón**: Controller + Observer (mediante `ValueNotifier`)
- **State Management**: Reactivo con `ValueNotifier<T>`

#### 3. **Capa de Presentación** (`view/`)
- **Responsabilidad**: Widgets UI y presentación visual
- **Componentes**:
  - `CurrencyPicker`: Widget compuesto (Dropdown + TextField)
  - `CurrencyTextField`: Widget de entrada con validación
  - `CurrencyTextView`: Widget de solo lectura
  - `CurrencyCardReport`: Widget de tarjeta para reportes
- **Patrón**: Stateful/Stateless Widgets + Composition
- **Comunicación**: Consume `CurrencyController` vía constructor injection

#### 4. **Capa de Utilidades** (`utils/`)
- **Responsabilidad**: Funciones auxiliares y helpers
- **Componentes**:
  - `AutoDecimalNumberFormatter`: `TextInputFormatter` customizado para formateo automático de decimales y separadores de miles
  - `getCurrencyDecoration()`: Factory para generar `InputDecoration` consistente
  - Mensajes de error localizados
- **Patrón**: Helper Functions + Strategy Pattern (TextInputFormatter)

#### 5. **Capa de Datos** (`assets/`)
- **Responsabilidad**: Fuentes de datos estáticas
- **Componentes**:
  - `supportedCurrencies`: Lista de ~150+ monedas con metadatos
  - `countryNames()`: Función para obtener nombres localizados
- **Patrón**: Repository Pattern (in-memory static data)

---

## 🧩 Componentes Principales

### 1. Currency Model

```dart
class Currency {
  String code;           // Código ISO 4217 (ej: 'USD', 'EUR')
  String name;           // Nombre completo de la moneda
  String symbol;         // Símbolo monetario (ej: '$', '€', '¥')
  String emoji;          // Emoji de bandera del país
  int decimalDigits;     // Número de decimales (0-4)
  String position;       // Posición del símbolo: 'first' | 'last'
}
```

**Características**:
- Serialización JSON (fromJson/toJson)
- Métodos de representación (toString, getDefaultView)
- Inmutable después de creación

### 2. CurrencyController

```dart
class CurrencyController {
  String lang;                              // Idioma para localización
  ValueNotifier<double?> mount;             // Estado reactivo del monto
  ValueNotifier<Currency?> _currency;       // Estado reactivo de la moneda
  
  Currency get currency;                    // Getter de moneda actual
  void set currency(Currency? currency);    // Setter de moneda
  void setMount(double? amount);            // Establecer monto
  Currency? getCurrencyByCode(String code); // Búsqueda de moneda
}
```

**Responsabilidades**:
- Gestión del estado de moneda y monto
- Notificación de cambios a listeners
- Búsqueda y validación de códigos de moneda
- Inicialización con idioma específico

### 3. Widgets de Presentación

#### CurrencyPicker
- **Tipo**: StatefulWidget
- **Propósito**: Selector completo de moneda con input de monto
- **Composición**: DropdownButton + TextField
- **Estado**: Gestiona selección local + sincroniza con controller
- **Features**:
  - Lista de todas las monedas soportadas
  - Input formateado automáticamente
  - Actualización reactiva del controller
  - Posicionamiento dinámico del símbolo

#### CurrencyTextField
- **Tipo**: StatelessWidget
- **Propósito**: Campo de entrada para moneda específica
- **Props**: `currencyCode` (fijo), `currencyController`
- **Features**:
  - Moneda predefinida (no cambia)
  - Validación de formato
  - Decoración automática según moneda
  - Input formatter integrado

#### CurrencyTextView
- **Tipo**: StatelessWidget
- **Propósito**: Visualización read-only de valores monetarios
- **Props**: `currencyCode`, `mount`, `currencyController`
- **Features**:
  - No editable
  - Formato correcto automático
  - Manejo de errores visual
  - Ideal para reportes

#### CurrencyCardReport
- **Tipo**: StatelessWidget
- **Propósito**: Tarjeta de reporte con valor monetario
- **Props**: `title`, `icon`, `mount`, `currencyCode`, `lang`, `style`
- **Features**:
  - Diseño tipo Card con elevación
  - Icono personalizable
  - Texto con estilo configurable
  - Crea su propio controller interno

---

## 🔧 Componentes Técnicos Internos

### AutoDecimalNumberFormatter

**Propósito**: TextInputFormatter personalizado para entrada de valores monetarios

```dart
class AutoDecimalNumberFormatter extends TextInputFormatter {
  final int decimalDigits;        // Decimales permitidos
  final String decimalSeparator;  // '.' por defecto
  final String thousandSeparator; // ',' por defecto
}
```

**Funcionalidad**:
1. Filtra solo dígitos de la entrada
2. Separa parte entera y decimal automáticamente
3. Aplica separadores de miles
4. Mantiene cursor en posición relativa correcta
5. Permite borrado completo

**Algoritmo**:
```
Input: "12345" con decimalDigits=2
1. Extrae dígitos: "12345"
2. Divide: integer="123", decimal="45"
3. Formatea integer con separadores: "123"
4. Resultado: "123.45"

Input: "1234567" con decimalDigits=2
1. Extrae dígitos: "1234567"
2. Divide: integer="12345", decimal="67"
3. Formatea integer: "12,345"
4. Resultado: "12,345.67"
```

### getCurrencyDecoration()

**Propósito**: Factory function para generar InputDecoration consistente

```dart
InputDecoration getCurrencyDecoration(
  Currency currency,
  CurrencyController currencyController
)
```

**Lógica**:
- Label: Emoji + nombre localizado de la moneda
- Prefix/Suffix: Posiciona símbolo según `currency.position`
  - `position='first'` → prefixText = symbol
  - `position='last'` → suffixText = symbol
- Consistencia visual en todos los widgets

---

## 📦 Flujo de Datos (Data Flow)

### Flujo de Entrada (Input Flow)

```
Usuario ingresa texto
    ↓
TextField.onChanged
    ↓
AutoDecimalNumberFormatter procesa
    ↓
TextField actualiza display
    ↓
onChanged callback ejecuta
    ↓
controller.mount.value = parsedDouble
    ↓
ValueNotifier notifica listeners
    ↓
Widgets que escuchan se actualizan
```

### Flujo de Selección (Selection Flow)

```
Usuario selecciona moneda en Dropdown
    ↓
onChanged callback ejecuta
    ↓
setState() actualiza UI local
    ↓
controller.currency = selectedCurrency
    ↓
ValueNotifier notifica cambio
    ↓
Widgets dependientes se actualizan
```

### Flujo de Visualización (Display Flow)

```
Controller tiene mount + currency
    ↓
Widget usa ListenableBuilder/ValueListenableBuilder
    ↓
Escucha cambios en controller.mount
    ↓
Builder reconstruye con nuevos valores
    ↓
CurrencyTextView renderiza formato correcto
```

---

## 🎯 Guía de Desarrollo para AI Agents

### Reglas de Desarrollo

1. **Immutabilidad de Currency**: El modelo `Currency` NO debe ser modificado después de creación
2. **Gestión de Estado**: SIEMPRE usar `ValueNotifier` para propiedades reactivas
3. **Dependency Injection**: Controllers se pasan vía constructor, NO usar singletons globales
4. **Localización**: Toda UI debe respetar el `lang` del controller
5. **Validación**: Códigos de moneda deben validarse con `getCurrencyByCode()` antes de usar

### Patrón de Implementación para Nuevos Widgets

```dart
class NewCurrencyWidget extends StatelessWidget {
  // 1. SIEMPRE requerir controller
  final CurrencyController currencyController;
  
  // 2. Props específicas del widget
  final String? additionalProp;
  
  // 3. Constructor con parámetros requeridos
  const NewCurrencyWidget({
    super.key,
    required this.currencyController,
    this.additionalProp,
  });
  
  @override
  Widget build(BuildContext context) {
    // 4. Validar datos
    final currency = currencyController.currency;
    if (currency == null) {
      return ErrorWidget('Currency not set');
    }
    
    // 5. Usar builders para reactividad
    return ValueListenableBuilder<double?>(
      valueListenable: currencyController.mount,
      builder: (context, mount, child) {
        // 6. Renderizar con datos validados
        return YourUIHere();
      },
    );
  }
}
```

### Testing Guidelines

**Para nuevos widgets**:
1. Crear mock de `CurrencyController`
2. Verificar renderizado con diferentes monedas
3. Probar casos edge: null, 0, valores negativos
4. Validar formato con diferentes `decimalDigits`
5. Comprobar localización (es/en mínimo)

**Para modificaciones**:
1. NO romper API pública existente
2. Mantener backward compatibility
3. Actualizar example/ con nuevas features
4. Documentar breaking changes en CHANGELOG.md

---

## 🔄 Extensión del Paquete

### Agregar Nueva Moneda

**Archivo**: `lib/src/assets/supported_currencies.dart`

```dart
Currency(
  code: "XYZ",                    // Código ISO 4217
  name: "Example Currency",       // Nombre oficial
  symbol: "¤",                    // Símbolo único
  emoji: "🏳️",                     // Emoji bandera
  decimalDigits: 2,               // 0-4 típicamente
  position: "first",              // 'first' o 'last'
),
```

**Pasos**:
1. Agregar entrada en `supportedCurrencies` list
2. Agregar traducción en `lib/src/assets/currencies_names/`
3. Actualizar tests
4. Regenerar si hay scripts de generación

### Agregar Nuevo Widget

**Estructura mínima**:
```dart
// 1. Imports
import 'package:currency_widget/currency_widget.dart';
import 'package:flutter/material.dart';

// 2. Widget class
class CurrencyNewWidget extends StatelessWidget {
  final CurrencyController currencyController;
  // ... otras props
  
  const CurrencyNewWidget({
    super.key,
    required this.currencyController,
  });
  
  @override
  Widget build(BuildContext context) {
    // Implementación
  }
}

// 3. Export en currency_widget.dart
export 'package:currency_widget/src/view/currency_new_widget.dart';
```

### Agregar Formatter Personalizado

**Extender TextInputFormatter**:
```dart
class CustomCurrencyFormatter extends TextInputFormatter {
  final Currency currency;
  
  CustomCurrencyFormatter({required this.currency});
  
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Tu lógica aquí
    return formattedValue;
  }
}
```

---

## 📝 Convenciones de Código

### Naming Conventions
- **Widgets**: PascalCase con prefijo `Currency` (ej: `CurrencyPicker`)
- **Controllers**: PascalCase con sufijo `Controller` (ej: `CurrencyController`)
- **Utilities**: camelCase para funciones (ej: `getCurrencyDecoration`)
- **Assets**: snake_case para archivos (ej: `supported_currencies.dart`)

### File Organization
```
- Un widget por archivo
- Nombre de archivo = nombre de clase en snake_case
- Archivos generados: comentario "// GENERATED FILE - DO NOT MODIFY"
- Barrel exports en archivos principales
```

### Documentation
- Todos los widgets públicos: documentación Dart con `///`
- Parámetros: describir propósito y valores válidos
- Ejemplos en dartdoc cuando sea complejo
- README.md actualizado con cada feature nueva

---

## 🚀 Comandos de Desarrollo

```bash
# Ejecutar ejemplo
cd example && flutter run

# Tests
flutter test

# Análisis de código
flutter analyze

# Formateo
dart format lib/ test/

# Generar documentación
dart doc .

# Publicar (maintainers)
flutter pub publish --dry-run
flutter pub publish
```

---

## 📚 Recursos para AI Agents

### Archivos Clave a Revisar
1. `lib/currency_widget.dart` - API pública
2. `lib/src/Controller/currency_controller.dart` - Lógica central
3. `lib/src/models/currency.dart` - Modelo de datos
4. `example/lib/main.dart` - Ejemplos de uso
5. `pubspec.yaml` - Dependencias y metadatos

### Patrones a Seguir
- **State Management**: ValueNotifier + ValueListenableBuilder/ListenableBuilder
- **Widget Composition**: Widgets pequeños y enfocados
- **Error Handling**: Null-safety + widgets de error visuales
- **Localization**: Soporte multi-idioma desde diseño

### Patrones a Evitar
- ❌ Estado global/singletons
- ❌ Widgets demasiado complejos (>300 líneas)
- ❌ Lógica de negocio en widgets
- ❌ Strings hardcodeados (usar localización)

---

## 💻 Ejemplos de Implementación

### Ejemplo 1: Uso Básico de CurrencyPicker

```dart
class SyncedCurrencyView extends StatefulWidget {
  @override
  State<SyncedCurrencyView> createState() => _SyncedCurrencyViewState();
}

class _SyncedCurrencyViewState extends State<SyncedCurrencyView> {
  final CurrencyController _controller = CurrencyController(lang: 'es');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Ingresa el monto:', style: TextStyle(fontSize: 18)),
        CurrencyPicker(currencyController: _controller),
        
        SizedBox(height: 30),
        Divider(),
        SizedBox(height: 30),
        
        Text('Vista del monto:', style: TextStyle(fontSize: 18)),
        ListenableBuilder(
          listenable: _controller.mount,
          builder: (context, _) {
            return CurrencyTextView(
              currencyCode: _controller.currency.code,
              mount: _controller.mount.value ?? 0,
              currencyController: _controller,
            );
          },
        ),
      ],
    );
  }
}
```

---

## 🌍 Idiomas Soportados

El paquete soporta localización mediante el parámetro `lang` del `CurrencyController`:

- `'es'` - Español
- `'en'` - Inglés
- Otros idiomas según la configuración del paquete

---

## ⚠️ Manejo de Errores

### Código de Moneda Inválido

```dart
final controller = CurrencyController(lang: 'es');

// Si el código no existe, retorna null
final currency = controller.getCurrencyByCode('invalid_code');

if (currency == null) {
  print('Moneda no encontrada');
}
```

### Widget con Moneda Inválida

```dart
// CurrencyTextView mostrará un error si la moneda no existe
CurrencyTextView(
  currencyCode: 'xyz', // Código inválido
  mount: 100,
  currencyController: controller,
)
// Mostrará: "Error loading currency" con un icono de error
```

---

## 🔧 Características Avanzadas

### Formateo Automático

El paquete incluye un `AutoDecimalNumberFormatter` que:
- Formatea automáticamente los decimales según la moneda
- Agrega separadores de miles
- Respeta el número de decimales de cada moneda

### Posicionamiento de Símbolo

Las monedas tienen una propiedad `position`:
- `'first'`: Símbolo al inicio (ej: $100.00)
- `'last'`: Símbolo al final (ej: 100.00€)

---

## 📱 Compatibilidad

- **Flutter**: >=3.0.0
- **Dart**: >=3.0.0 <4.0.0
- **Plataformas**: iOS, Android, Web, Windows, Linux, macOS

---

## 🐛 Reporte de Problemas

Para reportar problemas o contribuir al paquete:
- GitHub: https://github.com/DecksPlayer/currency_widget

---

## 💝 Apoyo al Proyecto

Si este paquete te resulta útil, considera apoyar su desarrollo:

[![PayPal](https://www.paypalobjects.com/webstatic/en_US/i/buttons/PP_logo_h_150x38.png)](https://www.paypal.com/paypalme/gonojuarez)

---

## 🧪 Testing Guidelines para AI Agents

### Unit Tests - Modelo Currency
```dart
test('Currency fromJson creates valid object', () {
  final json = {
    'code': 'USD',
    'name': 'US Dollar',
    'symbol': '\$',
    'emoji': '🇺🇸',
    'decimal_digits': 2,
    'position': 'first',
  };
  
  final currency = Currency.fromJson(json);
  
  expect(currency.code, 'USD');
  expect(currency.decimalDigits, 2);
  expect(currency.position, 'first');
});
```

### Widget Tests - Controllers
```dart
testWidgets('CurrencyController updates mount', (tester) async {
  final controller = CurrencyController(lang: 'en');
  
  controller.setMount(100.50);
  
  expect(controller.mount.value, 100.50);
});
```

### Integration Tests - Full Flow
```dart
testWidgets('CurrencyPicker updates on selection', (tester) async {
  final controller = CurrencyController(lang: 'en');
  
  await tester.pumpWidget(
    MaterialApp(
      home: CurrencyPicker(currencyController: controller),
    ),
  );
  
  // Simular interacción
  await tester.tap(find.byType(DropdownButton));
  await tester.pumpAndSettle();
  
  // Verificar estado
  expect(controller.currency, isNotNull);
});
```

---

## 🔐 Consideraciones de Seguridad

### Validación de Input
```dart
// SIEMPRE validar códigos de moneda
final currency = controller.getCurrencyByCode(userInput);
if (currency == null) {
  // Manejar error - código inválido
  return ErrorWidget('Invalid currency code');
}
```

### Sanitización de Valores
```dart
// El formatter ya sanitiza, pero validar rangos
if (controller.mount.value != null) {
  final amount = controller.mount.value!;
  if (amount < 0 || amount > maxAllowed) {
    // Manejar valor fuera de rango
  }
}
```

---

## 📝 Documentación para AI Agents

### Al Implementar Nuevas Features

1. **Actualizar exports** en `currency_widget.dart`
2. **Documentar** con dartdoc (///)
3. **Agregar ejemplo** en `example/lib/main.dart`
4. **Tests** unitarios y de widget
5. **Actualizar** CHANGELOG.md
6. **Version bump** en pubspec.yaml si es breaking change

### Code Review Checklist

- [ ] Sigue naming conventions del proyecto
- [ ] Documentación dartdoc completa
- [ ] Null-safety respetado
- [ ] Dispose implementado correctamente
- [ ] Tests agregados/actualizados
- [ ] Example app funciona correctamente
- [ ] No warnings en `flutter analyze`
- [ ] Formateado con `dart format`

---

## 🚀 Deployment Checklist

Antes de publicar nueva versión:

```bash
# 1. Tests pasan
flutter test

# 2. Análisis limpio
flutter analyze

# 3. Formateo correcto
dart format lib/ test/

# 4. Example funciona
cd example && flutter run

# 5. Dry-run
flutter pub publish --dry-run

# 6. Verificar archivos
# - CHANGELOG.md actualizado
# - pubspec.yaml version bumped
# - README.md actualizado si hay nuevas features

# 7. Publicar
flutter pub publish
```

---

## 📚 Referencias Técnicas

### Flutter Concepts Utilizados
- **StatefulWidget** / **StatelessWidget**
- **ValueNotifier** / **ValueListenableBuilder** / **ListenableBuilder**
- **TextInputFormatter**
- **InputDecoration**
- **DropdownButton**
- **TextField**

### Dart Patterns Aplicados
- **Controller Pattern**: Separación de lógica y UI
- **Observer Pattern**: ValueNotifier para reactividad
- **Factory Pattern**: Currency.fromJson
- **Dependency Injection**: Controllers vía constructor

### Best Practices Seguidas
- ✅ Null-safety habilitado
- ✅ Immutability donde sea posible
- ✅ Single Responsibility Principle
- ✅ Composition over Inheritance
- ✅ Clean Architecture (capas separadas)

---

## 🎓 Recursos Adicionales

### Para Entender el Código
1. Leer `lib/currency_widget.dart` (exports públicos)
2. Estudiar `CurrencyController` (core logic)
3. Revisar `CurrencyPicker` (widget más completo)
4. Examinar `example/lib/main.dart` (casos de uso reales)

### Para Extender el Paquete
1. Copiar estructura de widget existente
2. Seguir convenciones de naming
3. Implementar tests similares
4. Documentar con ejemplos

---

**Versión del Documento**: 2.0 (AI Agent Edition)  
**Última Actualización**: 28 Noviembre 2025  
**Versión del Paquete**: 0.0.14  
**Audiencia**: AI Development Agents  
**Propósito**: Guía técnica para desarrollo y mantenimiento
