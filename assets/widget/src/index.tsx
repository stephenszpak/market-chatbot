import { createRoot } from 'react-dom/client'
import AB from './ABInsightsAssistant'
import './styles.css'

declare global {
  interface Window { ABInsightsAssistant: any }
}

window.ABInsightsAssistant = {
  mount(selector: string){
    const el = document.querySelector(selector)
    if(!el) return
    const root = createRoot(el as HTMLElement)
    root.render(<AB />)
  }
}
