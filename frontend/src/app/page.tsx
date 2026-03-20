import Link from 'next/link'
import { Bot, FileText, MessageSquare, BarChart3, Shield, Zap } from 'lucide-react'

export default function HomePage() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900">
      {/* Header */}
      <header className="border-b border-white/10 backdrop-blur-sm">
        <div className="max-w-7xl mx-auto px-4 py-4 flex justify-between items-center">
          <div className="flex items-center gap-2">
            <Bot className="h-8 w-8 text-purple-400" />
            <span className="text-xl font-bold text-white">AI Product Platform</span>
          </div>
          <nav className="flex gap-4">
            <Link href="/login" className="text-gray-300 hover:text-white transition-colors">
              Login
            </Link>
            <Link href="/register" className="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-lg transition-colors">
              Get Started
            </Link>
          </nav>
        </div>
      </header>

      {/* Hero */}
      <main className="max-w-7xl mx-auto px-4 py-20 text-center">
        <h1 className="text-5xl font-bold text-white mb-6">
          AI-Powered Platform with
          <span className="text-purple-400"> Multi-Agent Orchestration</span>
        </h1>
        <p className="text-xl text-gray-300 mb-10 max-w-3xl mx-auto">
          Built with Claude Code, featuring specialized sub-agents for backend, frontend,
          database, LLM, monitoring, observability, and QA. Deployed on AWS.
        </p>
        <div className="flex gap-4 justify-center">
          <Link href="/dashboard" className="bg-purple-600 hover:bg-purple-700 text-white px-8 py-3 rounded-lg text-lg font-semibold transition-colors">
            Go to Dashboard
          </Link>
          <Link href="/chat" className="border border-white/20 hover:border-white/40 text-white px-8 py-3 rounded-lg text-lg font-semibold transition-colors">
            Try Chat
          </Link>
        </div>

        {/* Features */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mt-20">
          {[
            { icon: MessageSquare, title: 'AI Chat', desc: 'Multi-turn conversations with Claude Opus powered RAG' },
            { icon: FileText, title: 'Document Processing', desc: 'Upload, chunk, and query documents with vector search' },
            { icon: Bot, title: 'Agent Orchestration', desc: 'PO agent coordinates specialized sub-agents via Claude Code' },
            { icon: BarChart3, title: 'Monitoring', desc: 'Prometheus + Grafana observability stack' },
            { icon: Shield, title: 'Secure', desc: 'JWT auth, HTTPS, AWS IAM, encrypted storage' },
            { icon: Zap, title: 'Scalable', desc: 'ECS Fargate, RDS Aurora, auto-scaling on AWS' },
          ].map((feature, i) => (
            <div key={i} className="bg-white/5 border border-white/10 rounded-xl p-6 text-left hover:bg-white/10 transition-colors">
              <feature.icon className="h-8 w-8 text-purple-400 mb-3" />
              <h3 className="text-lg font-semibold text-white mb-2">{feature.title}</h3>
              <p className="text-gray-400">{feature.desc}</p>
            </div>
          ))}
        </div>
      </main>
    </div>
  )
}
