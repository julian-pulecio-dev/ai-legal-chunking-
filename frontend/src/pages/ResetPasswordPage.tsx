import { useState, type FormEvent } from 'react'
import { useNavigate, useLocation, Link } from 'react-router-dom'
import { authApi, ApiError } from '../api/authApi'

export function ResetPasswordPage() {
  const navigate = useNavigate()
  const location = useLocation()
  const [email, setEmail] = useState((location.state as { email?: string } | null)?.email ?? '')
  const [code, setCode] = useState('')
  const [newPassword, setNewPassword] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [submitting, setSubmitting] = useState(false)

  async function handleSubmit(e: FormEvent) {
    e.preventDefault()
    setError(null)
    setSubmitting(true)
    try {
      await authApi.confirmForgotPassword(email, code, newPassword)
      navigate('/login', { state: { confirmed: true } })
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'Reset failed')
    } finally {
      setSubmitting(false)
    }
  }

  return (
    <div className="auth-card">
      <h1>Nueva contraseña</h1>
      <form onSubmit={handleSubmit}>
        <label>
          Email
          <input type="email" value={email} onChange={(e) => setEmail(e.target.value)} required />
        </label>
        <label>
          Código
          <input type="text" value={code} onChange={(e) => setCode(e.target.value)} required />
        </label>
        <label>
          Nueva contraseña
          <input
            type="password"
            value={newPassword}
            onChange={(e) => setNewPassword(e.target.value)}
            minLength={8}
            required
          />
        </label>
        {error && <p className="error">{error}</p>}
        <button type="submit" disabled={submitting}>
          {submitting ? 'Guardando...' : 'Guardar contraseña'}
        </button>
      </form>
      <p>
        <Link to="/login">Volver a iniciar sesión</Link>
      </p>
    </div>
  )
}
