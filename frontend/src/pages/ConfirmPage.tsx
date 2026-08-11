import { useState, type FormEvent } from 'react'
import { useNavigate, useLocation, Link } from 'react-router-dom'
import { authApi, ApiError } from '../api/authApi'

export function ConfirmPage() {
  const navigate = useNavigate()
  const location = useLocation()
  const [email, setEmail] = useState((location.state as { email?: string } | null)?.email ?? '')
  const [code, setCode] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [info, setInfo] = useState<string | null>(null)
  const [submitting, setSubmitting] = useState(false)

  async function handleSubmit(e: FormEvent) {
    e.preventDefault()
    setError(null)
    setSubmitting(true)
    try {
      await authApi.confirm(email, code)
      navigate('/login', { state: { confirmed: true } })
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'Confirmation failed')
    } finally {
      setSubmitting(false)
    }
  }

  async function handleResend() {
    setError(null)
    setInfo(null)
    try {
      await authApi.resendConfirmation(email)
      setInfo('Código reenviado, revisá tu email.')
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'Could not resend code')
    }
  }

  return (
    <div className="auth-card">
      <h1>Confirmar email</h1>
      <form onSubmit={handleSubmit}>
        <label>
          Email
          <input type="email" value={email} onChange={(e) => setEmail(e.target.value)} required />
        </label>
        <label>
          Código de verificación
          <input type="text" value={code} onChange={(e) => setCode(e.target.value)} required />
        </label>
        {error && <p className="error">{error}</p>}
        {info && <p className="info">{info}</p>}
        <button type="submit" disabled={submitting}>
          {submitting ? 'Confirmando...' : 'Confirmar'}
        </button>
      </form>
      <button type="button" className="link-button" onClick={handleResend}>
        Reenviar código
      </button>
      <p>
        <Link to="/login">Volver a iniciar sesión</Link>
      </p>
    </div>
  )
}
