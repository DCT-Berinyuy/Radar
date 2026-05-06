---
name: Radar Design System
colors:
  surface: '#131313'
  surface-dim: '#131313'
  surface-bright: '#393939'
  surface-container-lowest: '#0e0e0e'
  surface-container-low: '#1c1b1b'
  surface-container: '#201f1f'
  surface-container-high: '#2a2a2a'
  surface-container-highest: '#353534'
  on-surface: '#e5e2e1'
  on-surface-variant: '#b9ccb2'
  inverse-surface: '#e5e2e1'
  inverse-on-surface: '#313030'
  outline: '#84967e'
  outline-variant: '#3b4b37'
  surface-tint: '#00e639'
  primary: '#ebffe2'
  on-primary: '#003907'
  primary-container: '#00ff41'
  on-primary-container: '#007117'
  inverse-primary: '#006e16'
  secondary: '#adc6ff'
  on-secondary: '#002e69'
  secondary-container: '#4b8eff'
  on-secondary-container: '#00285c'
  tertiary: '#fff8f4'
  on-tertiary: '#442b10'
  tertiary-container: '#ffd5ae'
  on-tertiary-container: '#7a5b3c'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#72ff70'
  primary-fixed-dim: '#00e639'
  on-primary-fixed: '#002203'
  on-primary-fixed-variant: '#00530e'
  secondary-fixed: '#d8e2ff'
  secondary-fixed-dim: '#adc6ff'
  on-secondary-fixed: '#001a41'
  on-secondary-fixed-variant: '#004493'
  tertiary-fixed: '#ffdcbd'
  tertiary-fixed-dim: '#e7bf99'
  on-tertiary-fixed: '#2c1701'
  on-tertiary-fixed-variant: '#5d4124'
  background: '#131313'
  on-background: '#e5e2e1'
  surface-variant: '#353534'
typography:
  h1:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: '1.2'
    letterSpacing: -0.02em
  h2:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: '1.3'
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.5'
  body-sm:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: '1.5'
  mono-data:
    fontFamily: JetBrains Mono
    fontSize: 14px
    fontWeight: '500'
    lineHeight: '1.2'
    letterSpacing: 0.02em
  mono-label:
    fontFamily: JetBrains Mono
    fontSize: 11px
    fontWeight: '700'
    lineHeight: '1'
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  unit: 4px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  gutter: 16px
  margin: 24px
---

## Brand & Style

The brand personality is high-performance, technical, and uncompromisingly precise. This design system is built for power users who require split-second decision-making capabilities in voice and media environments. The aesthetic mimics high-end rack-mounted hardware and professional digital audio workstations (DAWs).

The visual style is a fusion of **Technical Minimalism** and **High-Contrast Utility**. It prioritizes function over decoration, utilizing "engineered" visual cues such as thin hairline borders, strict grid alignments, and luminosity-based hierarchy. The emotional response is one of total control, reliability, and low-latency responsiveness.

## Colors

The "Signal" palette is optimized for visibility in dark environments. The primary color, **Cyber Green**, is reserved for active signals, critical actions, and successful data flows. **Electric Blue** provides a secondary accent for navigation and configuration highlights.

Backgrounds follow a strict hierarchical layering using Deep Charcoal and its derivatives to create depth without relying on traditional shadows. Active "Signal" elements should utilize a subtle outer glow (0-2px spread) to simulate the phosphor luminance of technical monitors.

## Typography

This design system employs a dual-font strategy. **Inter** handles all structural UI elements, providing a neutral and highly legible foundation for menus, settings, and general interface text. 

**JetBrains Mono** is used exclusively for technical readouts, latency metrics, timestamps, and waveform metadata. This distinction ensures the user can instantly differentiate between "system interface" and "technical data." All labels for toggles and meters should use JetBrains Mono in uppercase to reinforce the engineered aesthetic.

## Layout & Spacing

The layout philosophy follows a **Modular Grid** system. Content is organized into functional "modules" that can be rearranged or resized while maintaining a strict 4px baseline rhythm. 

Priority is given to real-time data visualizations. Waveform displays and signal meters should occupy the largest areas of the screen, with control panels docked in high-accessibility sidebars. The density is high; margins and gutters are kept tight (16px to 24px) to maximize the information displayed per square inch, reflecting its nature as a pro-level utility.

## Elevation & Depth

In this design system, depth is communicated through **Tonal Layering** and **Crisp Borders** rather than blurred shadows. Surfaces are stacked by increasing luminosity: the further "forward" an element is, the lighter its charcoal background becomes.

To define interactive areas, use 1px hairline borders in a slightly lighter shade than the background. For active or "on" states, use the primary or secondary color for the border. Elements do not "float"; they are "housed" within the UI frame. Subtle glows are permitted only for active signal indicators (LED-style) to denote live status.

## Shapes

The shape language is rigid and "engineered." A minimal roundedness of `0.25rem` (4px) is applied to buttons, input fields, and containers to prevent the UI from feeling overly aggressive while maintaining a precise, technical look. Circular shapes are strictly reserved for status indicators (LEDs) and specific rotary-style controls common in audio hardware.

## Components

### Buttons & Toggles
Buttons are flat with high-contrast text. The primary action button uses a solid Cyber Green fill with black text. Toggles should feel like physical switches, utilizing a 2nd-state "glow" border or indicator when active.

### Technical Chips
Data chips used for tags or status readouts should use a mono font and a subtle 1px border. They are used to categorize media formats, bitrates, and connection protocols.

### Input Fields
Inputs are deep-set (darker than the surrounding surface) with a thin border that illuminates in Electric Blue upon focus. The caret and text input for technical values should always use the monospace font.

### Waveform Displays
The centerpiece of the UI. Waveforms should be rendered in Cyber Green with high resolution. Background grids behind waveforms should be visible but subtle, utilizing the secondary color at 10% opacity.

### Icons
Icons must be thin-line (1px or 1.5px stroke) and geometric. Avoid rounded terminals; use butt caps for a more "plotted" look. Icons should be used sparingly, primarily as visual anchors for data types.

### Metrics & Gauges
VU meters and latency gauges should use segmented bars rather than smooth gradients to emphasize precision and discrete measurement levels.